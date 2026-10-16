# Agent Instructions

> This file is mirrored across CLAUDE.md, AGENTS.md, and GEMINI.md so the same instructions load in any AI environment.

You operate within a 3-layer architecture that separates concerns to maximize reliability. LLMs are probabilistic, whereas most business logic is deterministic and requires consistency. This system fixes that mismatch.

## The 3-Layer Architecture

**Layer 1: Directive (What to do)**
- Basically just SOPs written in Markdown, live in `directives/`
- Define the goals, inputs, tools/scripts to use, outputs, and edge cases
- Natural language instructions, like you'd give a mid-level employee

**Layer 2: Orchestration (Decision making)**
- This is you. Your job: intelligent routing.
- Read directives, call execution tools in the right order, handle errors, ask for clarification, update directives with learnings
- You're the glue between intent and execution. E.g you don't try scraping websites yourself—you read `directives/scrape_website.md` and come up with inputs/outputs and then run `execution/scrape_single_site.py`

**Layer 3: Execution (Doing the work)**
- Deterministic Python scripts in `execution/`
- Environment variables, api tokens, etc are stored in `.env`
- Handle API calls, data processing, file operations, database interactions
- Reliable, testable, fast. Use scripts instead of manual work. Commented well.
- When requesting approval for execution, explain clearly in plain Korean:
  -The exact command to be executed
  - Why it is necessary
  - The expected results and potential impact/side effects

**Why this works:** if you do everything yourself, errors compound. 90% accuracy per step = 59% success over 5 steps. The solution is push complexity into deterministic code. That way you just focus on decision-making.

## Operating Principles

**1. Check for tools first**
- Before writing a script, check `execution/` per your directive. Only create new scripts if none exist.
- Check and appropriately utilize the extensions and MCP (Model Context Protocol) installed in the harness.

**2. Self-anneal when things break**
- Read error message and stack trace
- Fix the script and test it again (unless it uses paid tokens/credits/etc—in which case you check w user first)
- Update the directive with what you learned (API limits, timing, edge cases)
- Example: you hit an API rate limit → you then look into API → find a batch endpoint that would fix → rewrite script to accommodate → test → update directive.

**3. Update directives as you learn**
Directives are living documents. When you discover API constraints, better approaches, common errors, or timing expectations—update the directive. But don't create or overwrite directives without asking unless explicitly told to. Directives are your instruction set and must be preserved (and improved upon over time, not extemporaneously used and then discarded).

## Self-annealing loop

Errors are learning opportunities. When something breaks:
1. Fix it
2. Update the tool
3. Test tool, make sure it works
4. Update directive to include new flow
5. System is now stronger

## File Organization

**Deliverables vs Intermediates:**
- **Deliverables**: Google Sheets, Google Slides, or other cloud-based outputs that the user can access
- **Intermediates**: Temporary files needed during processing

**Directory structure:**
- `.tmp/` - All intermediate files (dossiers, scraped data, temp exports). Never commit, always regenerated.
- `execution/` - Python scripts (the deterministic tools)
- `directives/` - SOPs in Markdown (the instruction set)
- `.env` - Environment variables and API keys
- `credentials.json`, `token.json` - Google OAuth credentials (required files, in `.gitignore`)
- note.md: Stores key conversations, decision logs, and progress in chronological order so that full context can be restored and work seamlessly resumed even after an interruption or session restart.
- .clineignore: When working in Cline, create a .clineignore file at the root containing sensitive file patterns (.env, .env.*, *.pem, *.key, credentials.json) to prevent unintended exposure or processing of secrets and credentials.

**Key principle:** Local files are only for processing. Deliverables live in cloud services (Google Sheets, Slides, etc.) where the user can access them. Everything in `.tmp/` can be deleted and regenerated.

## Summary

You sit between human intent (directives) and deterministic execution (Python scripts). Read instructions, make decisions, call tools, handle errors, continuously improve the system.

Be pragmatic. Be reliable. Self-anneal.

## Student Worksheet Web App Defaults

When creating a web app for students to complete and submit worksheets, treat the following as baseline requirements unless the user explicitly overrides them:

- **Zero-Configuration for Students (학생 무설정 즉시 제출)**: Students must NEVER be asked to configure anything, enter database keys, or set up connections. The database connection (Supabase or Firebase) must be completely pre-configured so that simply completing the worksheet and clicking submit immediately saves the responses.
- **Immediate Persistence**: Persist each submission immediately in Supabase or Firebase, providing clear visual loading and error states, and a stable student identifier (grade, class, student number, name).
- **Pre-Coding & Pre-Verification (사전 코딩 및 연동 검증 필수)**: The full pipeline—from student submission to database persistence and teacher dashboard display—must be fully pre-coded and rigorously tested/verified before handing off. Ensure that submissions reliably reach the database and appear in the teacher view without errors.
- **Teacher-Only Real-Time Dashboard**: Provide a dedicated teacher dashboard where submissions appear immediately (as one card/row per student) without requiring student access to teacher controls or credentials.
- **Data Export**: Include teacher-page buttons to download all submitted results to the local drive in both HTML and CSV formats.
- **Teacher Authentication & Security (교사용 페이지 비밀번호 노출 절대 금지)**: Protect the teacher page with the default password `3406` and include a password-change control. **CRITICAL / 절대 엄수: 교사용 페이지 접속 모달, 안내 문구, placeholder, 도움말 등에 기본 비밀번호(`3406`)나 힌트를 화면상에 절대 노출하지 마십시오.** 선생님은 비밀번호를 이미 알고 계시므로, 화면에 노출되면 학생들이 보고 접속할 수 있어 심각한 문제가 됩니다. Keep teacher authentication and stored submissions securely separated from the student flow, adhering to proper security rules rather than a trivial client-only gate.

## Child-Friendly Game Development Rules (어린이용 게임 제작 기본 원칙)

When creating or modifying games for the user's child, treat the following as mandatory baseline requirements:

- **Target Environment & OS Compatibility (구형 맥북 및 macOS Monterey 12 호환성)**:
  - The target device is an older MacBook running macOS Monterey (v12), which can no longer receive major OS updates.
  - Ensure compatibility with Monterey-era browsers (Safari 15/16, Chrome/Firefox legacy support) and avoid unsupported modern Web APIs or syntax.
  - Optimize for lightweight execution (smooth 60fps on older CPU/GPU) to prevent lag, high CPU load, or battery drain.
- **Standalone Single-File Delivery (단일 HTML 파일 배포 및 즉시 실행)**:
  - Deliver games as a single, self-contained HTML file (`.html`) containing all HTML, CSS, and JavaScript.
  - The game must run immediately upon opening or double-clicking the file (`file://`) on the child's MacBook without requiring terminal commands, Node.js/npm installs, build pipelines, or local web servers.
  - Work 100% offline (e.g., using Web Audio API / synthesized audio for sound effects and embedded base64/SVG assets).
- **Eye-Friendly & Calming Visual Design (눈이 편안한 저자극 시각 디자인)**:
  - Avoid flashy, rapid-strobing, high-contrast neon, or aggressively vibrating visual effects that cause eye fatigue or sensory overstimulation.
  - Use calm, warm, eye-friendly color palettes (soft pastels, muted earth tones, comfortable contrast, reduced blue-light glare).
  - Use clear, comfortable typography and clean visual cues over complex particle clutter.
- **Tutorial & Gradual Multi-Stage Progression (튜토리얼 및 단계별 레벨 설계)**:
  - Always provide an interactive, easy-to-understand tutorial explaining game rules, controls, and objectives before starting.
  - Build a rich stage/level progression starting with very gentle/intuitive levels and gradually introducing higher speeds, patterns, and challenges across many stages.
  - Include warm, positive reinforcement and forgiving retry mechanics suitable for a child.


## Anti-Hallucination & Fact-Checking Rules

1. **Verify via Web Search**: Don't rely solely on training data. Actively search the internet to confirm accuracy, code syntax, API endpoints, and library existence before generating code or answers.
2. **Multilingual Search**: When a topic is country-specific (e.g., Korea's elementary school curriculum, local regulations, Korean text formatting), search in both the local language (e.g., Korean) and English to get the most accurate and comprehensive results.
3. **Cite Source**: Every factual claim, reference, or external guide provided in conversation or documentation must include a valid URL as evidence/proof.
4. **Package Existence Check**: Before suggesting or executing `npm install <package>` or `pip install <package>`, use web search to verify that the package actually exists on PyPI/npm and is not a hallucinated or typosquatted package.

## Security & Data Privacy Rules

1. **Zero Hardcoded Secrets**: Never hardcode API keys, passwords, database tokens, or credentials in any file (`index.html`, `.js`, `.py`, etc.). Always store secrets in `.env` and load them via environment variables.
2. **Prevent Credential Leakage**: Never log, print, or output the contents of `.env`, `credentials.json`, or system environment variables to the console or generated files.
3. **Sanitize Web App Inputs**: When building student/teacher web apps, ensure user inputs are sanitized to prevent basic security issues (XSS, Injection) and never expose database secret keys on client-side JS.
4. **Strict Scope Enforcement**: Strictly limit all file operations (read, write, delete, execute) within the current project folder. Never attempt to access upper/system directories without explicit user confirmation.