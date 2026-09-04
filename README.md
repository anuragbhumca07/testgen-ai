# WMA-TestGen

**AI-Powered COBOL Test Case Generation for Annuity Policy Admin Systems**

WMA-TestGen reads a Business Systems Design (BSD) document and COBOL modules, then produces a complete, mathematically verified test suite with full traceability.

## Quick Start

```bash
npm install
npm start
# Open http://localhost:3000
```

## Generate PDF + Screenshots

```bash
# Make sure the server is running first (npm start), then:
npm run pdf
```

Output: `WMA-TestGen-Client-Pitch.pdf` + `screenshots/` folder.

## Pilot Case

BSD: **WMA-ANN-2026-0142** — Enhance Partial Withdrawal (Free-Withdrawal Allowance + Qualified-Plan Tax Withholding)
- Module: `WITHDRAW.cbl`
- Result: 20 test cases · 8/8 BRs · 3/3 error codes · 5 techniques

## Six-Phase Process

| Phase | Description |
|---|---|
| 1 | Ingest & Inventory |
| 2 | Data Domain Extraction |
| 3 | Rule & Path Analysis |
| 4 | Test Case Design |
| 5 | Expected-Result Computation |
| 6 | Self-Review Pass |

## GitHub

[github.com/anuragbhumca07/wma-testgen](https://github.com/anuragbhumca07/wma-testgen)
