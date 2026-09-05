# TestGen AI

**AI-Powered COBOL Test Case Generation for Annuity Policy Admin Systems**

TestGen AI reads your Business Systems Design (BSD) document and COBOL source files, then uses Claude Sonnet to generate a complete, mathematically verified test suite — covering every business rule, every error code, and every boundary condition.

---

## Table of Contents

1. [What It Does](#what-it-does)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Project Structure](#project-structure)
5. [How to Use — Web Interface](#how-to-use--web-interface)
6. [How to Use — Adding Your Own COBOL Files](#how-to-use--adding-your-own-cobol-files)
7. [How to Format Your BSD](#how-to-format-your-bsd)
8. [Understanding the Output](#understanding-the-output)
9. [Generate a PDF Report](#generate-a-pdf-report)
10. [Get a Public URL](#get-a-public-url)
11. [Deploy to Production](#deploy-to-production)
12. [Troubleshooting](#troubleshooting)

---

## What It Does

Given a BSD + COBOL module, TestGen AI runs a **6-phase analysis**:

| Phase | What Happens |
|---|---|
| **1 — Ingest & Inventory** | Lists all modules, copybooks, and maps COPY/CALL relationships |
| **2 — Data Domain Extraction** | Extracts PIC clauses, COMP-3 fields, 88-levels, and valid value ranges |
| **3 — Rule & Path Analysis** | Maps every BSD business rule to every IF/EVALUATE branch in the code; flags gaps |
| **4 — Test Case Design** | Applies EP, BVA, Decision-table, State-transition, and Annuity domain techniques |
| **5 — Expected-Result Computation** | Executes COBOL logic symbolically — shows arithmetic step-by-step |
| **6 — Self-Review** | Checks BR ↔ test coverage, validates PIC clause compliance, fills gaps |

**Output:** Three formal artifacts — Analysis Summary, Test-Case Suite (20+ cases), and a Test Plan ready to attach to your change record.

---

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Node.js | v18 or later | [nodejs.org](https://nodejs.org) |
| npm | v9 or later | Included with Node.js |
| Anthropic API Key | — | [console.anthropic.com](https://console.anthropic.com) |
| Microsoft Edge | Any modern | For PDF generation only |

---

## Installation

```bash
# 1. Clone the repository
git clone https://github.com/anuragbhumca07/testgen-ai.git
cd testgen-ai

# 2. Install dependencies
npm install

# 3. Add your Anthropic API key
#    Create a file named .env in the project root:
echo ANTHROPIC_API_KEY=sk-ant-your-key-here > .env

# 4. Start the server
npm start
```

Open **http://localhost:3000** in your browser.

---

## Project Structure

```
testgen-ai/
│
├── cobol/                        ← COBOL module source files (.cbl)
│   ├── WITHDRAW.cbl              ← Partial withdrawal (primary pilot module)
│   ├── PREMVAL.cbl               ← Premium validation
│   ├── PAYMENT.cbl               ← Payment processing
│   ├── POLISSUE.cbl              ← Policy issuance
│   ├── DEATHCLM.cbl              ← Death claim processing
│   ├── MATURITY.cbl              ← Maturity processing
│   ├── TRXREV.cbl                ← Transaction reversal
│   ├── TERMTRX.cbl               ← Termination transaction
│   ├── INTTRX.cbl                ← Interest transaction
│   └── COMPSET.cbl               ← Company setup
│
├── copybooks/                    ← Shared copybooks (.cpy)
│   ├── CPYPOLCY.cpy              ← Policy master record
│   ├── CPYTRANS.cpy              ← Transaction record
│   ├── CPYCOMPY.cpy              ← Company/carrier setup
│   └── CPYRATES.cpy              ← Surrender charge / rate table
│
├── bsd_sample/                   ← Sample BSD documents
│   └── BSD-WITHDRAW-ENH.md       ← Pilot: partial withdrawal enhancement
│
├── public/
│   └── index.html                ← Web UI (pitch + live demo)
│
├── prompts/
│   └── system.js                 ← TestGen AI system prompt (6-phase logic)
│
├── server.js                     ← Express server + Claude streaming API
├── generate-pdf.js               ← PDF + screenshot generator
├── .env.example                  ← API key template
└── render.yaml                   ← One-click Render.com deployment
```

---

## How to Use — Web Interface

1. **Start the server:** `npm start`
2. **Open:** http://localhost:3000
3. **Scroll to "Live AI Demo"** section
4. **Paste your BSD** into the left panel (a sample BSD is pre-loaded)
5. **Click "Analyze & Generate"** (or press `Ctrl + Enter`)
6. Watch Claude stream the full test suite in real time
7. Use the **Copy** button to export the output
8. The status bar shows token count and model name when done

---

## How to Use — Adding Your Own COBOL Files

### Step 1 — Drop your files in

```
cobol/          ← paste your .cbl files here
copybooks/      ← paste your .cpy files here
bsd_sample/     ← paste your BSD document here (.md or .txt)
```

### Step 2 — Open the demo and paste your BSD

In the web UI, clear the pre-loaded BSD and paste your own. Include:
- BSD ID and module name
- All business rules (BR-1, BR-2 …)
- All validation error codes (E301, E302 …)
- Acceptance criteria

Then paste the full contents of your COBOL module and copybooks into the BSD text area, separated by clear headings:

```
=== BSD ===
<your BSD content here>

=== COBOL MODULE: YOURMOD.CBL ===
<paste module source here>

=== COPYBOOK: CPYPOLCY.CPY ===
<paste copybook source here>
```

### Step 3 — Generate

Click **Analyze & Generate**. TestGen AI will:
- Map every business rule to a code path
- Flag any gaps (⚠ GAP) or assumptions (⚠ ASSUMPTION)
- Generate 15–30 test cases with computed expected values
- Produce a Requirements Traceability Matrix

---

## How to Format Your BSD

Use this template for best results:

```markdown
**BSD ID:** ANN-YYYY-XXXX
**Title:** <Enhancement description>
**Target Module:** YOURMOD.cbl
**Dependent Copybooks:** CPYPOLCY, CPYTRANS

## Background
<Brief description of what is changing and why>

## Business Rules
- BR-1: <Rule statement>
- BR-2: <Rule statement>
- BR-N: <Rule statement>

## Validation Requirements
- Policy must be INFORCE (status 'I'); else reject E301.
- <Field> must be positive; else reject E302.
- <Condition>; else reject E303.

## Acceptance Criteria
- <Measurable outcome 1>
- <Measurable outcome 2>
```

**Tips:**
- Number every business rule (BR-1, BR-2 …) — the agent traces these to test IDs
- Number every error code (E301, E302 …) — the agent guarantees one negative test per code
- Be explicit about field names if known — e.g. `LK-ACCT-VALUE`, `LK-WD-AMOUNT`

---

## Understanding the Output

The agent produces three artifacts:

### Artifact A — Analysis Summary
- Module and copybook inventory with call map
- Data domain table (field → PIC clause → valid range)
- Business rule ↔ code path reconciliation
- All gaps and assumptions explicitly flagged

### Artifact B — Test-Case Suite

Each test case looks like this:

```
Test ID      : TC-WITHDRAW-010
Title        : Q-plan above free allowance — surr charge + tax
Technique    : Decision-table
Traces To    : BR-1, BR-3, BR-4, BR-5, BR-7, BR-8
Precondition : Policy INFORCE ('I'), Qualified ('Q')
Input Fields :
  LK-ACCT-VALUE       = 100000.00
  LK-WD-AMOUNT        =  20000.00
  LK-SURR-CHARGE-PCT  =   0.0500
  LK-PRIOR-WD-YTD    =      0.00
  LK-PLAN-TYPE        = 'Q'
Expected Calculation :
  Free allow = 100000.00 × 0.10 − 0.00   = 10000.00
  Excess     = 20000.00 − 10000.00        = 10000.00
  Surr chg   = 10000.00 × 0.0500         =   500.00
  Tax w/h    = (20000.00 − 500.00) × 0.10=  1950.00
  Net WD     = 20000.00 − 500.00 − 1950  = 17550.00
  New AV     = 100000.00 − 20000.00      = 80000.00
Expected Outputs :
  LK-SURR-CHARGE-OUT  =   500.00
  LK-TAX-WITHHELD     =  1950.00
  LK-NET-WD           = 17550.00
  LK-NEW-ACCT-VALUE   = 80000.00
  LK-RETURN-CODE      = '0000'
Pass/Fail    : PASS if all output fields equal expected values exactly.
```

### Artifact C — Test Plan
Formal documentation covering purpose & scope, RTM, environment setup, execution notes, and a sign-off block — ready to attach to your change record.

---

## Generate a PDF Report

Make sure the server is running, then in a second terminal:

```bash
npm run pdf
```

This will:
1. Launch Microsoft Edge (headless)
2. Screenshot every section of the pitch page
3. Save `TestGen-AI-Client-Pitch.pdf` in the project root
4. Save all screenshots to `screenshots/`

---

## Get a Public URL

To share with colleagues or clients without deploying, use Cloudflare Quick Tunnel:

```bash
# Windows — run in the project folder
.\cloudflared.exe tunnel --url http://localhost:3000 --no-autoupdate
```

The terminal will print a URL like `https://something.trycloudflare.com`.  
No account required. URL is valid as long as your laptop is on.

> **Download cloudflared:** https://github.com/cloudflare/cloudflared/releases/latest

---

## Deploy to Production

### Option A — Render.com (Free tier, permanent URL)

1. Push this repo to GitHub (already done)
2. Go to [render.com](https://render.com) → New → Web Service
3. Connect your GitHub repo `anuragbhumca07/testgen-ai`
4. Render auto-detects `render.yaml` — click **Deploy**
5. In Environment settings, add: `ANTHROPIC_API_KEY = sk-ant-...`
6. Your permanent URL: `https://testgen-ai.onrender.com`

### Option B — Railway

```bash
npm install -g @railway/cli
railway login
railway init
railway up
railway variables set ANTHROPIC_API_KEY=sk-ant-...
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `apiKey: false` in health check | Create `.env` with `ANTHROPIC_API_KEY=sk-ant-...` and restart server |
| "Analyze & Generate" returns error | Check server console for API error; verify key is valid at console.anthropic.com |
| PDF generation fails | Ensure server is running on port 3000 before running `npm run pdf` |
| Cloudflare tunnel URL not working | Tunnel process died — restart with `.\cloudflared.exe tunnel --url http://localhost:3000` |
| Output cuts off mid-sentence | Increase `max_tokens` in `server.js` line ~45 from `8000` to `16000` |
| Port 3000 already in use | Change `PORT=3001` in `.env` or kill the existing process |

---

## Pilot Results — BSD ANN-2026-0142

Module tested: `WITHDRAW.cbl` (partial withdrawal enhancement)

| Metric | Result |
|---|---|
| Test cases generated | 20 |
| Business rules covered | 8 / 8 (100%) |
| Error codes covered | 3 / 3 (100%) |
| Techniques applied | EP, BVA, Decision-table, State-transition, COMP-3 edge |
| Time to generate | ~45 seconds |

---

## GitHub

[github.com/anuragbhumca07/testgen-ai](https://github.com/anuragbhumca07/testgen-ai)

---

*TestGen AI — AI-Powered COBOL QA Automation © 2026*
