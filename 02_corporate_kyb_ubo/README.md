# Case Study 2 — Corporate KYB and Beneficial Ownership

I used MySQL to review a fictional corporate KYC case involving a holding company and three individual beneficial owners. The goal was to find the people behind the business, check the ownership percentages and see what was still missing from the KYB file.

**Customer:** Phillips PLC (`client_id = 121`)  
**Review:** `REV-00121` — event-driven / ownership-opacity review  
**Tools:** MySQL Workbench, Excel for case notes  
**Status:** Review in progress; evidence not yet sufficient for closure

## What I did

I looked at the company registration and documents, checked the direct and indirect owners, calculated effective ownership, reviewed the draft risk/EDD records and listed outstanding information requests. I kept the queries simple so I could explain each step.

## Main findings

| Check | Finding |
|---|---|
| Business sector | Defense/Arms; High sector risk in source data |
| Ownership | 60% holding company / 40% direct individual |
| Effective individual holdings | 30%, 30%, 40% |
| Beneficial owner verification | All three pending |
| Company registration | Pending verification |
| Information requests | 2 overdue |
| QA | Open finding for incomplete UBO evidence |
| Overall risk | MEDIUM in a **draft** training assessment; needs review |
| Current KYB result | Keep in progress; do not clear yet |

The ownership percentage calculations are useful, but a complete KYB check also requires evidence about the actual shareholders and who controls the company.

## Files

- [`sql/investigation.sql`](sql/investigation.sql) — 26 read-only investigation queries
- [`docs/case_report.md`](docs/case_report.md) — what I found and my recommended action
- [`docs/query_explanation.md`](docs/query_explanation.md) — what, why and when for each query

## Data notes

This project uses **synthetic training data**. The client name, type, sector and risk flags come from the original Kaggle customer dataset. Ownership, KYC documents, case history, financial information and alerts were generated as fictional supporting records.

A source sectoral-sanctions flag is not proof of a legal sanctions match. The pack's `ubo_25pct_indicator` is a teaching label, not the applicable bank rule. I referenced the [RBI Commercial Banks KYC Directions, 2025](https://www.rbi.org.in/Scripts/BS_ViewMasDirections.aspx?id=13141) to understand beneficial ownership and control, rather than treating the dataset's 25% field as a legal threshold.

## My conclusion

The company structure is clear enough to calculate the three recorded ownership percentages, but the identity and supporting ownership documents remain unverified. I would follow up on those gaps, review the sector and screening concerns, and avoid closing the case until the KYB requirements are met.
