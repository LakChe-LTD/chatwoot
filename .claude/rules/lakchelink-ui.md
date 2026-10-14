# LakcheLink UI rules (all agents)

This fork of Chatwoot is the LakcheLink inbox. These rules come from [LC-ENG-PLAY-005 — Premium UI Playbook](https://lakchellc.atlassian.net/wiki/x/AYDwBw) and sit on top of the upstream guidelines in `CLAUDE.md` and `AGENTS.md`, which stay as upstream ships them. Claude Code loads this file from `.claude/rules/`; opencode loads it through `opencode.json`.

**Tooling.** `.mcp.json` (Claude Code) and `opencode.json` (opencode) configure the shadcn-vue MCP, Playwright MCP and Chrome DevTools MCP. In opencode the Playwright server is named `browser`.

- Read the `lakchelink-design` skill before any UI change.
- Leave upstream files untouched where you can and put fork-only work in new files, so syncs with chatwoot/chatwoot stay conflict-free.
- Restyle upstream screens through tokens (the colours in `tailwind.config.js` and the theme variables), not by editing upstream components.
- New LakcheLink screens start from upstream's `components-next/`. For a primitive it lacks, use shadcn-vue: search with the shadcn-vue MCP. This fork has no `components.json` yet; setting one up, with its registry list, needs Tech Lead and CISO approval.
- One motion moment per page, and respect `prefers-reduced-motion`.
- French is the primary language for LakcheLink: every label must fit the French string.
- Before calling UI work done: walk the changed screens with Playwright at 360 px and 1440 px, in French and English, and screenshot them; check console, network and speed with Chrome DevTools MCP; run `/impeccable critique` and fix what it finds.
- Agents and tests never touch a production inbox: use a local or staging instance and a test account.
