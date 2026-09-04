# Business Systems Design (BSD) — Sample Input

**BSD ID:** ANN-2026-0142
**Title:** Enhance Partial Withdrawal — Add Free-Withdrawal Allowance & Qualified-Plan Tax Withholding
**Target Module:** WITHDRAW.cbl
**Dependent Copybooks:** CPYPOLCY, CPYTRANS
**Author:** Business Analyst
**Date:** 2026-08-15

## 1. Background
The current partial withdrawal function applies a surrender charge on the
entire withdrawal amount. Product wants to introduce a free-withdrawal
allowance (10% of account value per policy year) that is exempt from
surrender charges. Additionally, for Qualified (Q) plans, 10% federal tax
must be withheld on the taxable portion.

## 2. Business Rules
- BR-1: Free-withdrawal allowance = 10% of current account value per policy year.
- BR-2: Prior year-to-date withdrawals reduce the remaining free allowance.
- BR-3: Surrender charge applies ONLY to the excess above the free allowance.
- BR-4: Surrender charge = excess amount × surrender charge percent (from rate table).
- BR-5: For Qualified plans, tax withheld = (withdrawal − surrender charge) × 10%.
- BR-6: For Non-Qualified plans, no tax withheld.
- BR-7: Net withdrawal = gross withdrawal − surrender charge − tax withheld.
- BR-8: New account value = account value − gross withdrawal.

## 3. Validation Requirements
- Policy must be INFORCE (status 'I'); else reject E301.
- Withdrawal amount must be positive; else reject E302.
- Withdrawal cannot exceed account value; else reject E303.

## 4. Acceptance Criteria
- Withdrawal within free allowance incurs zero surrender charge.
- Withdrawal above free allowance charges only the excess.
- Qualified plan reflects 10% withholding; Non-Qualified reflects none.
- Account value correctly reduced by the gross amount.
