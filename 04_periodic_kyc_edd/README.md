# Case Study 4 — Periodic KYC Review and EDD Assessment

I worked on an overdue periodic KYC review using MySQL and a synthetic training dataset. The objective was to check the customer file, understand why the review was still pending, identify incomplete follow-up and assess whether the draft customer risk rating needed another review.

**Customer:** Olson, Evans and Thomas (`client_id = 36`)  
**Review:** `REV-00036`  
**Case status:** `PENDING_CUSTOMER`  
**Tools:** MySQL Workbench, Markdown/Excel for investigation notes  
**Reference date:** 18 November 2026

## What I checked

I reviewed the case due date, customer details, documents, address consistency, the outstanding information request, case events, financial profile, screening-alert records, draft risk score, EDD records and QA findings. I also ran simple checks to make sure document, request and QA records were linked to the right customer.

## Main findings

| Area | Finding |
|---|---|
| Periodic review | Due 15 October 2026; **34 days overdue** |
| Customer information | Individual; crypto-exchange sector recorded as High risk |
| Passport | Simulated verified record; expires 10 January 2028, **not expired** |
| Address proof | Simulated verified record; address matches profile |
| Information request | One overdue identity-refresh request; **17 days past due** |
| Timing | Identity-refresh request raised 6 days after review deadline |
| Screening | No alert row for this customer in the training pack; no screening clearance claimed |
| Overall risk | Draft MEDIUM rating, requiring explanation against the High sector factor |
| EDD | No EDD record found; applicability needs a policy-based decision |
| QA | One open finding about the overdue request |

## My conclusion

I would keep this review pending, follow up on the information request, clarify why a new identity record was needed, and send the risk-rating and EDD questions to the appropriate reviewer. I would not approve the case simply because the documents are currently marked verified.

## Project files

- [`sql/investigation.sql`](sql/investigation.sql) — 26 read-only SQL queries
- [`docs/case_report.md`](docs/case_report.md) — investigation narrative and recommended action
- [`docs/query_explanation.md`](docs/query_explanation.md) — What, Why and When for each query

## Data notes

Customer category, name, sector and customer-level flags come from the original synthetic Kaggle dataset. Case timelines, identity records, financial details, risk assessment and QA records were generated for training. All conclusions are limited to the available evidence and do not represent a real banking investigation.
