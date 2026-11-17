# Case Study 3 — PEP, Sanctions and Adverse-Media Screening

I used MySQL to review a fictional screening alert for an existing customer. The main question was whether the available information justified clearing the alert, treating it as a confirmed match or requesting more verification.

**Customer:** Hoffman-Frost (`client_id = 341`)  
**Review:** `REV-00341` — event-driven PEP review  
**Tools:** MySQL Workbench, Excel/Markdown for notes  
**Status:** Pending customer information and screening verification

## What I checked

I reviewed the assigned case, identity records, PEP screening candidate, sanctions alert records, adverse-media lead, draft risk assessment and outstanding requests. I also checked that the screening and document records were linked to the right customer.

## Main findings

| Area | What I found |
|---|---|
| PEP flag | 1 in the original customer data |
| PEP alert | One fictional candidate, SCR-00028, with matching name, DOB and country |
| PEP decision | Cannot confirm or dismiss from the fictional alert alone |
| Screening source | SIMULATED_INTERNAL_WATCHLIST; no verified political role supplied |
| Sanctions | No recorded sanctions alerts; this is **not** clearance |
| Adverse media | One fictional, unverified business-licensing lead |
| Identity | Simulated passport expired on 1 March 2025 |
| Information request | One request marked overdue, due 1 November 2026 |
| Customer risk | Draft MEDIUM only, not approved |
| Review status | PENDING_CUSTOMER |

## My conclusion

I would keep the case open, follow up on the screening evidence, refer the potential PEP match for further verification and flag the expired identity document. I would not call the candidate a confirmed PEP or treat the fictional media allegation as a fact.

## Files

- [`sql/investigation.sql`](sql/investigation.sql) — 24 read-only SQL queries
- [`docs/case_report.md`](docs/case_report.md) — case findings and recommendation
- [`docs/query_explanation.md`](docs/query_explanation.md) — What, Why and When for each query

## Data notes

The customer's original name, sector, country and risk flags come from the Kaggle synthetic customer dataset. Supporting documents, PEP candidate, adverse-media lead and case workflow were generated for training. There is **no verified real-person screening result** for this customer in the pack.

I used a fixed reference date of **18 November 2026** for expiry and overdue checks so the exercise gives the same results when rerun.
