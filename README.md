# @kiranbuildswithai — Craft System v1.1
**An agency-style operating system for building websites with AI agents.** v1.0 compiled by GPT from the Claude research doc; v1.1 fixes and tooling by Claude, 11 October 2026. See `CHANGELOG.md`.

## What it is for
Every AI session starts with no memory of your standards. Without this system, each Claude or GPT chat improvises its own process, picks the statistically average design, skips research, and calls the job done without checking it. This pack makes every session, in every tool, start from the same:

1. **Process**: nine gates from client intake to published case study, with an approval question at each.
2. **Rules**: one `AGENTS.md` that Claude Code, Codex and Cursor all read.
3. **Defaults with numbers**: type, spacing, motion, performance and accessibility values with sources.
4. **Project memory**: a `design/` folder per website holding the brief, brand, tokens, locks and decisions, so the next session knows what was agreed.
5. **Checks**: a token validator, a screenshot + accessibility script and a Lighthouse command, so "done" means measured.
6. **Content output**: case-study and social templates that turn each build into posts.

What it does **not** do: supply taste, real photography, customer insight or client approval. Those stay with you. A pass from the QA script is not a real-device test.

**Core principle:** site quality = specific insight + distinctive art direction + clear user journey + precise execution + real proof. Motion and 3D are optional tools, not the identity.

## Where the files live
| Copy | Location | Purpose |
|---|---|---|
| **Master** | A private GitHub repo, e.g. `kiran-craft-system`, cloned on your computer | The one place you edit the system. Version history for free. |
| **Per website** | `AGENTS.md`, `CLAUDE.md`, `craft/`, `design/` in each project's root | What coding agents read while building that site |
| **Chat apps** | Files uploaded to a Claude Project and a ChatGPT Project | Planning, briefs and critique in claude.ai / chatgpt.com |

Folder contract inside a website project:
```
your-site/
├── AGENTS.md        ← shared rules (all coding agents)
├── CLAUDE.md        ← one line: @AGENTS.md (Claude Code entry point)
├── craft/           ← shared system; never edit inside a client project
│   ├── library/     ← principles, motion/scroll/3D, standards, studio atlas, source audit
│   ├── agent/       ← six role prompts, critic scorecard
│   ├── templates/   ← brief, brand, tokens, motion spec, research kit, case study
│   ├── qa/          ← validate_tokens.py, screens.mjs, qa-commands.md
│   ├── social/      ← editorial engine, post drafts, lead magnet
│   └── vendor/      ← Vercel Web Interface Guidelines (MIT)
└── design/          ← THIS client only: creative-brief.md, brand.md, tokens.json,
                       motion-spec.md, research-kit.md, DECISIONS.md, qa-output/
```

## Install into a website project
**Linux / macOS / WSL / Git Bash:**
```bash
bash /path/to/kiran-craft-system/install.sh /path/to/your-site
```
**Windows PowerShell:**
```powershell
.\install.ps1 -Destination C:\path\to\your-site
```
Copies `AGENTS.md` and `craft/`, creates or extends `CLAUDE.md`, seeds `design/` from the templates, and automatically installs **Impeccable** design skills (`.claude`, `.cursor`, `.agents`, etc.) plus the CLI anti-pattern detector. Re-running it updates `craft/` and never touches `design/`.

## How each tool picks it up
| Tool | How it reads the system |
|---|---|
| **Claude Code** | Reads `CLAUDE.md` at session start, which imports `AGENTS.md`. Recent versions also read `AGENTS.md` directly. Impeccable commands (`/typeset`, `/polish`, `/critique`, etc.) available natively in chat. [Docs](https://code.claude.com/docs/en/memory) |
| **OpenAI Codex** | Reads `AGENTS.md` from the project root down to the working folder (and `~/.codex/AGENTS.md`), up to 32 KiB combined by default. [Docs](https://learn.chatgpt.com/docs/agent-configuration/agents-md) |
| **Cursor** | Reads root `AGENTS.md` and project/global skills in `.cursor/skills`. |
| **Antigravity / Gemini** | Reads workspace `.agents/` and global customizations. Impeccable skills loaded into `.agents/skills/impeccable`. |
| **claude.ai Project** | Paste `AGENTS.md` into the Project instructions; upload `craft/library/*`, `craft/agent/*` and `craft/templates/*` as Project files. |
| **ChatGPT Project** | Same: paste `AGENTS.md` into Project instructions; upload the same files. |

Agents read the deep `craft/` files only when a task needs them. Keep `AGENTS.md` short; it is loaded into every session. Impeccable skills provide interactive design refining (`/shape`, `/typeset`, `/layout`, `/bolder`, `/harden`, `/polish`, `/critique`, `/audit`) and anti-pattern detection (`npx impeccable detect .`).

## How to run one website through it
1. Install (above). Fill `design/creative-brief.md`; list locked features under "Existing features that must not change".
2. G1 research with `design/research-kit.md` (customer conversations are yours to do).
3. G2–G4 in a chat Project or coding agent: insight, three directions, chosen concept, section map, `brand.md`, `tokens.json`, one `motion-spec.md`.
4. G5–G6 build with the coding agent. It must run `craft/qa/` and attach the report.
5. G7 critique: open a **fresh** chat, give it only the brief, screenshots, `qa-report.json` and URL, plus `craft/agent/critic-scorecard.md`.
6. G8 publish: `craft/templates/case-study.md` plus 3–5 posts from `craft/social/`.

## The nine gates
| Gate | Required output | Owner hat | Approval question |
|---|---|---|---|
| G0 Intake | Client goal, primary action, constraints, existing assets | Strategist | What business decision should the website change? |
| G1 Research | 3–5 actual customer observations (when feasible), 3 competitor notes, journey map | Researcher | What do real users ask, fear, and misunderstand? |
| G2 Concept | One-sentence distinctive idea + 3 art-direction routes | Art director | Could this concept fit a competitor unchanged? If yes, revise. |
| G3 Content | Section map answering user questions; draft in the customer's words | Content lead | Can a visitor understand the offer without animation? |
| G4 Direction signoff | Approved direction, asset map, tokens, 1 signature motion spec | Art director | Does the visual system serve the actual business? |
| G5 Prototype | Above-the-fold responsive version plus hardest interaction prototype | Creative engineer | Do we need WebGL or is CSS/video enough? |
| G6 Build | Components, responsive behaviour, keyboard and reduced-motion experiences | Developer | Is real content always accessible? |
| G7 Critique/QA | QA report, screenshots, scorecard, real phone check | Independent critic | Would we be happy to show it beside the reference studios? |
| G8 Publish | Case study with only verified results, 3–5 social edits, client CTA | Publisher | Does this show both creative taste and business value? |

For small fixes on an existing site, skip to G6 and stay inside the approved direction.

## Updating the system
Edit the master repo, commit, then re-run `install.sh` on each active project. Record what changed in `CHANGELOG.md`. Re-upload changed files to your Claude and ChatGPT Projects.

## Scope and honesty
A selected cross-section of studios, not every award-winning agency. Awwwards wins show recognition, not proven business results. Agency case studies are self-reported. Rules marked `[Studio rule]` or `[Budget hypothesis]` are policies to test, not web standards. `craft/library/source-audit.md` lists what is verified and what is not. Mark spec projects as spec; never present them as client work.
