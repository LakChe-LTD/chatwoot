# Running Chatwoot Locally

This guide is for this local checkout at `/Users/nathanyinka/Desktop/chatwoot`.

## Pinned Release Baseline

This fork is pinned on branch `lakchelink-main` at Chatwoot tag `v4.15.1`.

That is the current baseline for the LakcheLink work and it already includes the TikTok and voice-related code paths needed for the next phase.

## Start The App

From the repo root:

```sh
cd /Users/nathanyinka/Desktop/chatwoot
export PATH="/opt/homebrew/opt/node@24/bin:/opt/homebrew/bin:$PATH"
eval "$(rbenv init -)"
overmind start -f Procfile.dev
```

Open the app:

```text
http://localhost:3000
```

## Login

```text
Email: john@acme.inc
Password: Password1!
```

## What Starts

`overmind start -f Procfile.dev` starts:

- Rails backend on `http://localhost:3000`
- Vite frontend asset server on `http://localhost:3036/vite-dev`
- Sidekiq worker

## Stop The App

Press `Ctrl + C` in the terminal running Overmind.

## Required Services

Postgres and Redis should be running:

```sh
brew services start postgresql@17
brew services start redis
```

Quick checks:

```sh
/opt/homebrew/opt/postgresql@17/bin/pg_isready -h localhost -p 5432 -d postgres
redis-cli ping
```

Redis should return:

```text
PONG
```

## If You See A Bundler Error

If you see:

```text
You must use Bundler 2 or greater with this lockfile.
```

Your terminal is using macOS system Ruby instead of rbenv Ruby. Run:

```sh
export PATH="/opt/homebrew/opt/node@24/bin:/opt/homebrew/bin:$PATH"
eval "$(rbenv init -)"
ruby -v
which ruby
bundle -v
```

The expected Ruby is:

```text
ruby 3.4.4
/Users/nathanyinka/.rbenv/shims/ruby
Bundler version 2.5.16
```

Then start the app again:

```sh
overmind start -f Procfile.dev
```

## Reset The Development Database

Use this only when you want to wipe local development data and recreate the seeded demo data:

```sh
cd /Users/nathanyinka/Desktop/chatwoot
export PATH="/opt/homebrew/opt/node@24/bin:/opt/homebrew/bin:$PATH"
eval "$(rbenv init -)"
bundle exec rails db:drop db:create db:schema:load db:seed
```

Do not use `db:migrate` for a full fresh replay in this checkout; an old historical migration currently fails with the installed gem versions. Use `db:schema:load` for a clean local reset.
