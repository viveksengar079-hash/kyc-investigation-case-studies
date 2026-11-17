# KYC & Financial Crime Due Diligence — SQL Case Studies

Seven portfolio exercises using **synthetic customer records and fictional KYC workflow evidence**. Each case simulates the decisions a junior KYC/CDD analyst might document. **These are learning projects, not work performed for a bank or verified investigations of real people.**

## Case studies

| # | Investigation | SQL queries | Case study |
|---|---|---:|---|
| 1 | Individual KYC & Event-Driven Review | 22 | [Open case](01_individual_kyc/README.md) |
| 2 | Corporate KYB & Beneficial Ownership | 26 | [Open case](02_corporate_kyb_ubo/README.md) |
| 3 | PEP, Sanctions & Adverse Media Screening | 24 | [Open case](03_pep_sanctions_adverse_media/README.md) |
| 4 | Periodic KYC Review & EDD Assessment | 26 | [Open case](04_periodic_kyc_edd/README.md) |
| 5 | KYC Remediation & Document Exceptions | 26 | [Open case](05_kyc_remediation/README.md) |
| 6 | High-Risk CDD, Source of Funds & Wealth | 27 | [Open case](06_high_risk_cdd/README.md) |
| 7 | New Customer Onboarding & KYC Decision | 25 | [Open case](07_customer_onboarding/README.md) |

## How I approached the work

- Read the case assignment and customer or company profile.
- Checked the available documentation, screening records, customer risk information, and relevant workflow evidence.
- Used straightforward, **read-only MySQL queries** to investigate data and validate record relationships.
- Documented the evidence, missing items, limitations, and an **L1 recommendation**, without claiming authority to approve or close the case.

## Repository structure

Every case includes `README.md`, `sql/investigation.sql`, `docs/case_report.md`, and `docs/query_explanation.md`. Internal expected-result sheets and test notes are kept separately, outside this public portfolio.

## Tools and reproducing the exercises

The scripts use **MySQL / MySQL Workbench**. The `USE kyc_case_studies;` statement assumes the synthetic customer data and generated KYC workflow tables have already been imported into a MySQL schema named `kyc_case_studies`.

**The source datasets and database setup scripts are not included in this repository archive.** Therefore the SQL files cannot run independently from a fresh clone. Time-sensitive investigation calculations use a fixed reference date of 18 November 2026 where noted.

A README and a documented SQL investigation are provided for each case so the investigative reasoning can still be reviewed without running the database.

## Evidence and scope

- The base customer/transaction records came from a synthetic training dataset; additional documents, reviews, flags, risk assessments and screening records were created as **fictional** exercise material.
- A PEP/sanctions indicator or candidate match is not a confirmed match; an absent alert is not proof of completed screening.
- Risk ratings, EDD decisions and QA findings remain hypothetical where described as draft, pending or unverified.
- Transaction context in individual cases is not a full transaction-monitoring investigation.
- Figures labelled `SCU` (simulated currency units) cannot be directly compared with source transactions whose currency is unspecified.

## Skills demonstrated

Customer due diligence (CDD) · KYB and beneficial ownership · PEP/sanctions screening review · Periodic KYC · Remediation · Source-of-funds / source-of-wealth assessment · Enhanced due diligence (EDD) · New-customer onboarding · Case documentation and escalation.
