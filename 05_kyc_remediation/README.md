# Case Study 5 — KYC Remediation and Document Exceptions

This is a practical KYC file review I did using MySQL and a synthetic customer dataset. The customer had an expired passport, a document-refresh request that was overdue, and a periodic KYC review that was still in progress. My goal was to identify the actual missing information and recommend what the analyst should do next.

**Client ID:** 1085  
**Review:** REV-01085  
**Tools:** MySQL Workbench and Markdown for case notes  
**Reference date:** 18 November 2026

## What I did

I checked the case details, reviewed the documents on file, confirmed the passport's expiry date, checked the recorded address, read the overdue request and case history, and looked at the existing risk and QA statuses. I also checked that the case records were linked to the correct customer.

## Main findings

- The passport expired on **1 March 2025**. The address proof is recorded as verified and the addresses match.
- The information request was due **1 November 2026** and was **17 days overdue** on the reference date.
- The periodic review was due **5 November 2026** and was **13 days overdue**.
- A High sector-risk factor and sectoral-sanctions indicator require review, but they do not establish a sanctions match.
- The overall MEDIUM rating is only a preliminary training proposal, not an approved customer risk rating.
- QA is PENDING with no specific defect recorded.

## What I recommended

Keep the KYC review open, follow up for an acceptable replacement identity document, document the outstanding request, and refer the risk-rating questions for review. I would not claim the case is complete until the missing evidence is verified.

## Files

- [`sql/investigation.sql`](sql/investigation.sql) — 26 straightforward, read-only SQL queries
- [`docs/case_report.md`](docs/case_report.md) — full investigation findings and L1 recommendation
- [`docs/query_explanation.md`](docs/query_explanation.md) — What, Why and When for each query

## Why this is relevant to KYC jobs

The case covers checking document completeness, following up on overdue information requests, maintaining accurate case status, recognizing risk-assessment gaps and deciding when to escalate. These are useful skills for junior KYC operations and remediation roles.

## Data note

This is **synthetic training data**, not a real customer investigation. Customer identity, sector and flags were inherited from a synthetic Kaggle dataset; documents, due dates and workflow records were added for training. The original source classifies the company-style name as an individual, so I would verify the classification rather than quietly change it.
