# LakcheLink

[English](LAKCHELINK.md) · **Français**

La branche `lakchelink-main` est **LakcheLink**, la plateforme d'engagement client en marque blanche de LakChe LLC, avec l'assistant Kora, construite sur Chatwoot Community Edition. Le reste de ce dépôt est le Chatwoot d'origine. Ce fichier décrit ce que LakChe modifie et comment y travailler ; le `README.md` et l'`AGENTS.md` d'origine décrivent toujours le code lui-même.

> **Ce dépôt est public.** Ne commitez jamais d'identifiant, d'adresse de serveur, de nom d'hôte interne, de chemin personnel, ni de document qui en contient. Les détails d'exploitation vivent sur Confluence, dans l'espace LakChe Link, et les valeurs dans le gestionnaire de mots de passe.

## Branches

| Branche | Rôle |
|---|---|
| `develop` | La branche par défaut du fork, qui suit `chatwoot/chatwoot` |
| `lakchelink-main` | LakcheLink : Chatwoot v4.15.1 (17 juin 2026) et les modifications de LakChe depuis le 9 juillet 2026 ([LL-11](https://lakchellc.atlassian.net/browse/LL-11)) |

L'application est servie sur support.lakchelink.com. [LL-17](https://lakchellc.atlassian.net/browse/LL-17) prévoit la production sur app.lakchelink.com.

## Ce que LakChe modifie

| Domaine | Où |
|---|---|
| Marque | `lib/lakchelink/branding.rb` contient les réglages de l'installation : nom, logos, liens de la marque et du widget, et bandeau de mise à jour désactivé. `bundle exec rake lakchelink:apply_branding` les applique à une installation en service. Les valeurs par défaut sont aussi dans `config/installation_config.yml`, les éléments de marque dans `public/brand-assets/` et les icônes dans `public/` ([LL-14](https://lakchellc.atlassian.net/browse/LL-14)) |
| Inscription et connexion | `app/javascript/v3/views/auth/signup/` et `app/javascript/v3/views/login/`, avec les contrôleurs correspondants dans `app/controllers/devise_overrides/` |
| E-mail | Resend (`gem 'resend'`), via `config/initializers/mailer.rb` et `app/mailers/application_mailer.rb`. `.env.example` liste les noms : `RESEND_API_KEY`, `MAILER_SENDER_EMAIL` et `SMTP_DOMAIN` |
| Image et services | `docker/Dockerfile` et `docker-compose.production.yaml` |
| Déploiements | `.github/workflows/deploy_lakchelink.yml` |

## Déploiements

Le workflow construit l'image, la pousse dans GitHub Container Registry et la déploie avec Docker Compose ([LL-15](https://lakchellc.atlassian.net/browse/LL-15)).

- **Un push sur `lakchelink-main` ne déploie en staging que si le message du dernier commit commence par `deploy:` ou `[deploy]`.** Tout autre message, fusion de pull request comprise, ne déploie rien.
- **Un lancement manuel déploie la référence choisie en staging ou en production.** Le formulaire propose la production par défaut : choisissez en connaissance de cause.
- Un déploiement en production exige l'accord écrit du CTO sur son ticket.
- Les secrets du workflow vivent dans les environnements GitHub `staging` et `production`. Le fichier du workflow donne leurs noms.

## Reprendre les mises à jour de Chatwoot

1. Partez d'une version stable publiée par Chatwoot. Ne suivez jamais la branche `develop` d'origine.
2. Fusionnez-la dans une branche créée depuis `lakchelink-main`, et ouvrez une pull request.
3. Avant la mise en production, lancez :
   - la vérification des traces de Chatwoot ([LL-115](https://lakchellc.atlassian.net/browse/LL-115)) : aucun « Chatwoot » visible dans les écrans, les e-mails ou le widget ;
   - les specs modifiées par LakChe : `spec/builders/account_builder_spec.rb`, `spec/controllers/devise/omniauth_callbacks_controller_spec.rb`, `spec/mailers/application_mailer_spec.rb` et `spec/services/account/sign_up_email_validation_service_spec.rb`.
4. Placez le travail propre à LakChe dans des fichiers propres à LakChe quand c'est possible (`lib/lakchelink/`, `LAKCHELINK*.md`, `.claude/rules/`), pour que chaque fusion reste petite.

## Licence

- En dehors de `enterprise/`, Chatwoot est sous licence MIT. Gardez `LICENSE` et la mention de copyright, même en retirant la marque Chatwoot visible ([LL-114](https://lakchellc.atlassian.net/browse/LL-114)).
- Le code de `enterprise/` relève de la licence Chatwoot Enterprise (`enterprise/LICENSE`), qui n'autorise un usage en production qu'avec un abonnement Chatwoot. N'activez aucune fonction Enterprise sans une décision du CTO.

## Travailler sur LakcheLink

1. **Partez d'un ticket Jira du projet LL.** Un ticket par branche et par pull request, vers `lakchelink-main`, moins de 400 lignes modifiées, relue et fusionnée par quelqu'un d'autre que l'auteur.
2. **Créez la branche** sous la forme `{type}/{vous}/{LL-nn-nom-court}` et écrivez des Conventional Commits. N'oubliez pas que `deploy:` au début d'un message de commit déploie le staging.
3. **Agents :** l'`AGENTS.md` d'origine (lu aussi comme `CLAUDE.md`) s'applique au code. Les règles de LakChe pour les agents sont dans `.claude/rules/`.
4. **Testez** sur une instance locale ou de staging avec un compte de test, jamais sur une boîte de réception ou des données de production.
5. **Secrets :** désignez-les par leur nom uniquement. Si vous en trouvez un dans le dépôt ou son historique, arrêtez-vous et prévenez le Tech Lead et le CISO. Il est renouvelé, pas seulement supprimé.
6. **Les consignes orales** qui modifient un ticket y sont notées le jour même, en une ligne, par la personne qui les a reçues ([règle](https://lakchellc.atlassian.net/wiki/pages/viewpage.action?pageId=106856449)).

## Liens

| Quoi | Où |
|---|---|
| Tickets LakcheLink | Jira, projet LL |
| Fork et branche | [LL-11](https://lakchellc.atlassian.net/browse/LL-11) |
| Changement de marque, et retrait des traces de Chatwoot | [LL-14](https://lakchellc.atlassian.net/browse/LL-14), [LL-114](https://lakchellc.atlassian.net/browse/LL-114), [LL-115](https://lakchellc.atlassian.net/browse/LL-115) |
| Image et production | [LL-15](https://lakchellc.atlassian.net/browse/LL-15), [LL-17](https://lakchellc.atlassian.net/browse/LL-17) |
| Outils d'interface pour les agents | [LC-54](https://lakchellc.atlassian.net/browse/LC-54) |
| Cette documentation | [LC-57](https://lakchellc.atlassian.net/browse/LC-57) |
| Definition of Done | [LAKCHE-ENG-GOV-001 §3.4](https://lakchellc.atlassian.net/wiki/pages/viewpage.action?pageId=38928386) |
