# Case Study 6 — High-Risk CDD, Source of Funds and Source of Wealth

I used MySQL to review a high-risk KYC file from a synthetic training dataset. The main question was whether the customer's financial background had enough supporting evidence for Enhanced Due Diligence (EDD).

**Customer:** Smith-Wright (Client 1877)  
**Review:** REV-01877 — Periodic KYC  
**Tools:** MySQL Workbench and Markdown  
**Fixed review date:** 18 November 2026

## What I checked

I started with the assigned KYC review and the customer's profile. I then checked the document records, the open PEP alert, source-of-funds and source-of-wealth declarations, the draft risk assessment and the EDD status. I used a small transaction summary only to understand the customer's recorded activity. This was **not** a full transaction-monitoring investigation.

## Main findings

- The customer is recorded as an **Individual** in **VE**, with **High** sector risk for **Crypto Exchange** and an original `pep_flag = 1`.
- There is one **open simulated PEP alert**. The recorded political position is not independently verified, so this is not a confirmed PEP.
- Source of funds is **Professional fees**; source of wealth is **Inheritance and investments**. Both are **self-declared** in the synthetic financial record.
- The proposed **HIGH** risk band is still `DRAFT_PENDING_REVIEW`. The training score is not an official bank risk model.
- EDD is `NOT_STARTED`, with no funds/wealth verification completed and management approval not requested.
- The periodic review was due **13 November 2026**. It was **5 days past due** on the fixed reference date.
- The training pack has **no existing information request** for this customer. That does not prove no request exists in a real bank.

## What I recommended

I would keep the KYC review open and refer the customer for appropriate EDD checks. I would request documents or reliable information to support the professional-fees income and the reported inheritance/investments, clarify the customer's crypto-exchange-related business activity, and review the underlying PEP alert. The final risk rating and any approval should remain with the authorized reviewer.

## Project files

- [`sql/investigation.sql`](sql/investigation.sql) — 27 simple read-only queries
- [`docs/case_report.md`](docs/case_report.md) — my investigation notes and recommendation
- [`docs/query_explanation.md`](docs/query_explanation.md) — What, Why and When for each query

## Job relevance

This case demonstrates high-risk customer review, the difference between source of funds and source of wealth, evidence gaps, screening referral, and EDD escalation. These are useful skills for KYC Operations, AML/KYC Analyst and screening-focused roles.

## Data note

The number *Case Study 6* follows our KYC-only portfolio plan. The old generated `case_study_index.csv` still uses `CS06` for a separate fraud exercise; it is **not** the case assignment used here. We use the customer, KYC review and EDD tables for Client 1877 instead.

The client name, category, sector and screening flags come from an **original synthetic Kaggle dataset**. The KYC workflow, personal profile, financial declarations, screening candidate, documents and EDD records were **generated for training**. Nothing here is a real customer investigation or a completed regulatory screening decision. The original transactions have no declared currency and must not be directly compared with the synthetic financial amounts labelled SCU.
