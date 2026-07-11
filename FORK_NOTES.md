# Fork Notes — LakChe-LTD/chatwoot

This is a fork of [Chatwoot CE](https://github.com/chatwoot/chatwoot) maintained by LakChe LLC as the base platform for **LakcheLink** (https://lakchelink.com), a white-label customer engagement product.

## Why a separate file instead of editing README.md

Upstream's `README.md` is left untouched to keep syncs with `chatwoot/chatwoot` conflict-free. Fork-specific documentation lives here.

## Conventions

- Base branch tracks upstream **`develop`**
- LakcheLink customizations are developed on feature branches prefixed `ll/` and documented internally
- Do not commit proprietary or internal configuration to this fork while it is public

## Upstream sync

```bash
git remote add upstream https://github.com/chatwoot/chatwoot.git
git fetch upstream
git merge upstream/develop
```

## License

Upstream Chatwoot licensing applies to inherited code (see `LICENSE` in this repository).
