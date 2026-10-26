# LakcheLink fork rules (all agents)

The branch `lakchelink-main` of this fork is LakcheLink, LakChe LLC's customer engagement platform. These rules sit on top of upstream's guidelines in `AGENTS.md` (also read as `CLAUDE.md`), which stay as upstream ships them. Read [LAKCHELINK.md](../../LAKCHELINK.md) before any change. Claude Code loads this file from `.claude/rules/`.

- **This repository is public.** Never commit, paste or print any of the following:
  - a credential;
  - a server or database address, or an internal hostname;
  - a personal path;
  - a document that holds any of them.

  That applies to code, docs, commits, pull requests and comments alike. Operational details live on Confluence, and values in the password manager. If you find one already committed, stop and tell the Tech Lead and the CISO: it is rotated, not just deleted.
- **A commit message that starts with `deploy:` or `[deploy]` deploys staging** once it lands on `lakchelink-main`. Use that prefix only when the ticket asks for a deploy. Never start a manual production run without the CTO's written go on the ticket.
- Keep LakChe changes in LakChe-only files where you can (`lib/lakchelink/`, `LAKCHELINK*.md`, `.claude/rules/`), and keep upstream files close to upstream, so release merges stay small.
- Branding changes go through `lib/lakchelink/branding.rb` and `config/installation_config.yml`. Check the result with the Chatwoot-trace check (LL-115).
- Keep `LICENSE` and every copyright notice.
- Do not turn on `enterprise/` features. They need a Chatwoot subscription (`enterprise/LICENSE`) and a decision from the CTO.
- Upstream updates come from a stable release tag, through a pull request. Never track upstream `develop`.
- Test against a local or staging instance with a test account, never a production inbox or production data.
- Work only from an LL ticket, one ticket per pull request, under 400 changed lines. Someone other than the author reviews and merges.
- Commit messages follow upstream's rule: Conventional Commits, and no reference to Claude.

*Résumé (FR) : ce dépôt est public. Aucun identifiant, adresse de serveur, nom d'hôte interne ni chemin personnel, nulle part. Un message de commit qui commence par `deploy:` déploie le staging ; la production exige l'accord écrit du CTO. Gardez LICENSE, n'activez pas `enterprise/`, testez hors production.*
