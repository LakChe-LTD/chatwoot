# LakcheLink

**English** · [Français](LAKCHELINK.fr.md)

The branch `lakchelink-main` is **LakcheLink**, LakChe LLC's white-label customer engagement platform with the Kora assistant, built on Chatwoot Community Edition. The rest of this repository is upstream Chatwoot. This file covers what LakChe changes and how to work on it; upstream's `README.md` and `AGENTS.md` still describe the code itself.

> **This repository is public.** Never commit a credential, a server address, an internal hostname, a personal path, or a document that holds any of them. Operational details live on Confluence, in the LakChe Link space, and values live in the password manager.

## Branches

| Branch | Role |
|---|---|
| `develop` | The fork's default branch, tracking upstream `chatwoot/chatwoot` |
| `lakchelink-main` | LakcheLink: upstream v4.15.1 (17 Jun 2026) plus LakChe's changes since 9 Jul 2026 ([LL-11](https://lakchellc.atlassian.net/browse/LL-11)) |

The app is served at support.lakchelink.com. [LL-17](https://lakchellc.atlassian.net/browse/LL-17) plans production at app.lakchelink.com.

## What LakChe changes

| Area | Where |
|---|---|
| Branding | `lib/lakchelink/branding.rb` holds the installation settings: name, logos, brand and widget links, and the update banner turned off. `bundle exec rake lakchelink:apply_branding` applies them to a running install. The defaults are also in `config/installation_config.yml`, the brand assets in `public/brand-assets/`, and the icons in `public/` ([LL-14](https://lakchellc.atlassian.net/browse/LL-14)) |
| Sign-up and sign-in | `app/javascript/v3/views/auth/signup/` and `app/javascript/v3/views/login/`, with the matching controllers in `app/controllers/devise_overrides/` |
| Mail | Resend (`gem 'resend'`), through `config/initializers/mailer.rb` and `app/mailers/application_mailer.rb`. `.env.example` lists the names: `RESEND_API_KEY`, `MAILER_SENDER_EMAIL` and `SMTP_DOMAIN` |
| Image and services | `docker/Dockerfile` and `docker-compose.production.yaml` |
| Deploys | `.github/workflows/deploy_lakchelink.yml` |

## Deploys

The workflow builds the image, pushes it to GitHub Container Registry and deploys it with Docker Compose ([LL-15](https://lakchellc.atlassian.net/browse/LL-15)).

- **A push to `lakchelink-main` deploys to staging only when the head commit message starts with `deploy:` or `[deploy]`.** Any other message, including a pull-request merge, deploys nothing.
- **A manual run deploys the ref you choose to staging or production.** The form defaults to production, so choose deliberately.
- A production deploy needs the CTO's written go on its ticket.
- The workflow's secrets live in the `staging` and `production` GitHub environments. Its own file gives their names.

## Updating from upstream

1. Start from a stable upstream release tag. Never track upstream `develop`.
2. Merge it into a branch cut from `lakchelink-main`, and open a pull request.
3. Before promoting it, run:
   - the Chatwoot-trace check ([LL-115](https://lakchellc.atlassian.net/browse/LL-115)): no visible "Chatwoot" in the screens, mails or widget;
   - the specs LakChe changed: `spec/builders/account_builder_spec.rb`, `spec/controllers/devise/omniauth_callbacks_controller_spec.rb`, `spec/mailers/application_mailer_spec.rb` and `spec/services/account/sign_up_email_validation_service_spec.rb`.
4. Put LakChe-only work in LakChe-only files where you can (`lib/lakchelink/`, `LAKCHELINK*.md`, `.claude/rules/`), so each upstream merge stays small.

## Licence

- Outside `enterprise/`, Chatwoot is MIT-licensed. Keep `LICENSE` and the copyright notice, even while removing visible Chatwoot branding ([LL-114](https://lakchellc.atlassian.net/browse/LL-114)).
- Code under `enterprise/` is under the Chatwoot Enterprise licence (`enterprise/LICENSE`), which allows production use only with a Chatwoot subscription. Do not turn on enterprise features without a decision from the CTO.

## Working on LakcheLink

1. **Work from a Jira ticket in the LL project.** One ticket per branch and per pull request, against `lakchelink-main`, under 400 changed lines, reviewed and merged by someone other than the author.
2. **Branch** as `{type}/{you}/{LL-nn-short-name}`, and write Conventional Commits. Remember that `deploy:` at the start of a commit message deploys staging.
3. **Agents:** upstream's `AGENTS.md` (also read as `CLAUDE.md`) applies to the code. LakChe's rules for agents are in `.claude/rules/`.
4. **Test** against a local or staging instance with a test account, never a production inbox or production data.
5. **Secrets:** refer to them by name only. If you find one in the repository or its history, stop and tell the Tech Lead and the CISO. It is rotated, not just deleted.
6. **Verbal directions** that change a ticket go on that ticket the same day, in one line, written by whoever received them ([rule](https://lakchellc.atlassian.net/wiki/pages/viewpage.action?pageId=106856449)).

## Links

| What | Where |
|---|---|
| LakcheLink tickets | Jira, project LL |
| Fork and branch | [LL-11](https://lakchellc.atlassian.net/browse/LL-11) |
| Rebrand, and removing Chatwoot traces | [LL-14](https://lakchellc.atlassian.net/browse/LL-14), [LL-114](https://lakchellc.atlassian.net/browse/LL-114), [LL-115](https://lakchellc.atlassian.net/browse/LL-115) |
| Image and production | [LL-15](https://lakchellc.atlassian.net/browse/LL-15), [LL-17](https://lakchellc.atlassian.net/browse/LL-17) |
| Agent UI tooling | [LC-54](https://lakchellc.atlassian.net/browse/LC-54) |
| These docs | [LC-57](https://lakchellc.atlassian.net/browse/LC-57) |
| Definition of Done | [LAKCHE-ENG-GOV-001 §3.4](https://lakchellc.atlassian.net/wiki/pages/viewpage.action?pageId=38928386) |
