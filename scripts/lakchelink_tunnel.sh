#!/usr/bin/env bash

set -euo pipefail

SSH_HOST="${SSH_HOST:-72.62.192.213}"
SSH_USER="${SSH_USER:-root}"
POSTGRES_LOCAL_PORT="${POSTGRES_LOCAL_PORT:-5432}"
REDIS_LOCAL_PORT="${REDIS_LOCAL_PORT:-6379}"
POSTGRES_REMOTE_HOST="${POSTGRES_REMOTE_HOST:-127.0.0.1}"
POSTGRES_REMOTE_PORT="${POSTGRES_REMOTE_PORT:-5432}"
REDIS_REMOTE_HOST="${REDIS_REMOTE_HOST:-127.0.0.1}"
REDIS_REMOTE_PORT="${REDIS_REMOTE_PORT:-6379}"
PID_FILE="${PID_FILE:-${TMPDIR:-/tmp}/lakchelink-tunnel.pid}"
ENV_FILE="${ENV_FILE:-$HOME/.lakchelink.env}"

SSH_TARGET="${SSH_USER}@${SSH_HOST}"
SSH_OPTS=(
  -o ExitOnForwardFailure=yes
  -o ServerAliveInterval=60
  -o ServerAliveCountMax=3
  -o StrictHostKeyChecking=accept-new
)

usage() {
  cat <<'EOF'
Usage:
  lakchelink_tunnel.sh up
  lakchelink_tunnel.sh down
  lakchelink_tunnel.sh status
  lakchelink_tunnel.sh psql
  lakchelink_tunnel.sh redis

Optional env:
  SSH_HOST, SSH_USER
  POSTGRES_LOCAL_PORT, REDIS_LOCAL_PORT
  POSTGRES_USERNAME, POSTGRES_PASSWORD, POSTGRES_DATABASE
  REDIS_PASSWORD
  ENV_FILE
EOF
}

load_env_file() {
  if [[ -f "$ENV_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
  fi
}

pid_running() {
  [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start_tunnel() {
  if pid_running; then
    echo "Tunnel already running: $(cat "$PID_FILE")"
    return 0
  fi

  ssh -fN \
    "${SSH_OPTS[@]}" \
    -L "${POSTGRES_LOCAL_PORT}:${POSTGRES_REMOTE_HOST}:${POSTGRES_REMOTE_PORT}" \
    -L "${REDIS_LOCAL_PORT}:${REDIS_REMOTE_HOST}:${REDIS_REMOTE_PORT}" \
    "$SSH_TARGET"

  local pid
  pid="$(
    pgrep -f "ssh .*${SSH_TARGET}.*${POSTGRES_LOCAL_PORT}:${POSTGRES_REMOTE_HOST}:${POSTGRES_REMOTE_PORT}.*${REDIS_LOCAL_PORT}:${REDIS_REMOTE_HOST}:${REDIS_REMOTE_PORT}" \
      | head -n 1 || true
  )"

  if [[ -n "$pid" ]]; then
    printf '%s\n' "$pid" > "$PID_FILE"
  else
    rm -f "$PID_FILE"
  fi

  echo "Tunnel up."
  echo "Postgres -> 127.0.0.1:${POSTGRES_LOCAL_PORT}"
  echo "Redis    -> 127.0.0.1:${REDIS_LOCAL_PORT}"
}

stop_tunnel() {
  if ! [[ -f "$PID_FILE" ]]; then
    echo "No tunnel pid file found."
    return 0
  fi

  local pid
  pid="$(cat "$PID_FILE")"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
    echo "Tunnel stopped."
  else
    echo "Tunnel pid file exists but process is gone."
  fi
  rm -f "$PID_FILE"
}

show_status() {
  if pid_running; then
    echo "running: $(cat "$PID_FILE")"
  else
    echo "stopped"
  fi
}

open_psql() {
  load_env_file
  : "${POSTGRES_USERNAME:?Set POSTGRES_USERNAME in your local env file}"
  : "${POSTGRES_PASSWORD:?Set POSTGRES_PASSWORD in your local env file}"
  : "${POSTGRES_DATABASE:?Set POSTGRES_DATABASE in your local env file}"

  start_tunnel
  exec env PGPASSWORD="$POSTGRES_PASSWORD" psql \
    -h 127.0.0.1 \
    -p "$POSTGRES_LOCAL_PORT" \
    -U "$POSTGRES_USERNAME" \
    -d "$POSTGRES_DATABASE"
}

open_redis() {
  load_env_file
  : "${REDIS_PASSWORD:?Set REDIS_PASSWORD in your local env file}"

  start_tunnel
  exec redis-cli \
    -h 127.0.0.1 \
    -p "$REDIS_LOCAL_PORT" \
    -a "$REDIS_PASSWORD"
}

main() {
  case "${1:-}" in
    up)
      start_tunnel
      ;;
    down)
      stop_tunnel
      ;;
    status)
      show_status
      ;;
    psql)
      open_psql
      ;;
    redis)
      open_redis
      ;;
    ""|-h|--help|help)
      usage
      ;;
    *)
      echo "Unknown command: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
