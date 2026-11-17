# Case Study 7 — New Customer Onboarding and KYC Decision

I used MySQL to check a new customer's onboarding file in a synthetic KYC dataset. Unlike the previous periodic and event-driven reviews, this is an applicant who has **not** been onboarded yet.

**Applicant:** Synthetic Applicant 2001 (Client 2001)  
**Review:** REV-02001  
**Type:** Individual onboarding  
**Tools:** MySQL Workbench, SQL, Markdown  
**Reference date:** 18 November 2026

## What I wanted to find out

My main question was whether the applicant's file had enough verified information to move forward. I checked the customer declaration, identity and address records, screening evidence, draft risk assessment, case history and QA findings.

## How I worked

1. I confirmed that this was a **new application** and checked the pending account status.
2. I compared the applicant's recorded details with the passport and address-proof entries.
3. Both document names and the addresses matched in the file, but **both verification statuses were PENDING**.
4. I checked the PEP and sanctions indicators. They were zero, but there was no recorded screening search or alert review for this applicant, so I could not say the screening process was completed.
5. I checked the declared financial background and draft customer risk rating.
6. I reviewed the open QA finding for missing document verification and checked whether any information request had already been made.
7. I compared the final application, account, risk and QA statuses before writing my recommendation.

## What I found

| Check | Finding |
|---|---|
| Application | IN_PROGRESS; new customer |
| Account | PENDING_OPEN, no open date |
| Passport | Not expired, verification PENDING |
| Address proof | Recorded address matches, verification PENDING |
| Financial information | SELF_DECLARED (SCU is a synthetic unit) |
| Screening | No search log or alert row available; completion not demonstrated |
| Risk | LOW is only a TRAINING_PRELIMINARY proposal |
| QA | OPEN_FINDING: MISSING_DOCUMENT_VERIFICATION |
| Prior transactions | None in the original transaction table |

## My recommendation

I would **keep onboarding pending**. First, the document checks should be completed and the open QA finding corrected. I would also confirm that the required PEP/sanctions screening has actually been carried out and recorded, rather than assuming that zero flags mean the check is complete. Any extra financial evidence should be requested based on the company's risk-based policy, not automatically.

I did not approve or activate the account. The SQL file is read-only and the risk score is a training example, not a bank-approved model.

## Project files

- [SQL investigation](sql/investigation.sql)
- [Case report](docs/case_report.md)
- [What, Why and When for all 25 queries](docs/query_explanation.md)

## Data note

This is a **synthetic, simulated applicant**. Names, addresses, document references and workflow records are not real banking customer information. A document record is not an authenticated passport or utility bill, and a missing screening row is not proof of a clear search result.
