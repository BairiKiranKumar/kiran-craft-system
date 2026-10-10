# Changelog

## v1.1 — 11 October 2026 (Claude review of GPT's v1.0)
**Structure**
- One `AGENTS.md` at the root (v1.0 had two identical copies). Added `CLAUDE.md` that imports it.
- Shared system moved under `craft/`; per-project files live in `design/`. All internal paths updated.
- Added `install.sh`: installs/updates a project, seeds `design/` once, never overwrites it.
- Removed Aarambh-specific lines from shared files; project locks now live in each project's `design/creative-brief.md`.

**Rules**
- Directive 3 (three visual directions) now applies only to new sites, pages and redesigns (G2–G4).
- Added measured defaults for type, spacing, motion and tap targets with sources (`craft/library/design-principles.md`, AGENTS directive 7).
- Split agent-runnable checks from human-only checks (real devices, field vitals, user tests).
- Added `transform`/`opacity` as *preferred*, not exclusive (corrects the Claude memo).
- Vendored Vercel's Web Interface Guidelines (MIT, unmodified, licence included).

**Tokens**
- `tokens.example.json` rewritten to DTCG 2025.10: colour values are `{colorSpace, components, hex}` objects (v1.0 used invalid hex strings).
- Added typography (families, weights, fluid size steps, line heights, measure), radius scale, `onAction`, and `borderStrong` (3.01:1 on canvas for inputs).

**QA tooling (new)**
- `craft/qa/validate_tokens.py`: DTCG type, unit and alias checks.
- `craft/qa/screens.mjs`: 10 screenshots (5 widths × normal/reduced motion) plus overflow, alt text, control names, labels, h1, lang, title, autoplay-without-pause, and content-hidden-under-reduced-motion checks.
- `craft/qa/qa-commands.md`: setup, validator, screenshots, Lighthouse, human-only list.

**Source fixes**
- Instrument Eames wording corrected ("maintainable CMS", not "composable").
- `source-audit.md` gained v1.1 rows for every new verified claim.

**Verification run**
- Validator: new example 63 tokens, 0 errors; v1.0 file correctly fails (7 errors).
- `screens.mjs`: catches all 9 planted failures on a broken test page; 0 failures on a clean page.
- Lighthouse command tested: runs and reports LCP/TBT/CLS.
- `install.sh`: fresh install, re-run without overwriting `design/`, existing `CLAUDE.md` extended once.

## v1.0 — 11 October 2026 (GPT)
Initial pack: nine gates, AGENTS rules, six role prompts, critic scorecard, studio atlas, templates, social engine.
