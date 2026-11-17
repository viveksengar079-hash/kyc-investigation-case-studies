# Individual KYC Review — Case Study 01

**Case:** REV-01708  
**Customer:** Burton-Acosta (Client ID 1708)  
**Review type:** Event-driven KYC review  
**Tools:** MySQL Workbench, Excel, Dilisense (name-search exercise)  
**Case status:** Open — more information required

## About this case

I worked through a simulated KYC review for an existing individual customer whose record had a PEP flag. My aim was to understand what an L1 KYC analyst would check before recommending a decision.

I used MySQL to review the customer's profile, KYC documents, screening alerts, financial background, risk assessment, and outstanding information requests. I also looked at a short transaction summary for customer context, not as a full transaction monitoring investigation.

This is a **training case, not work performed for a real bank**. The original customer and transaction records came from a synthetic Kaggle dataset. The additional documents, internal screening alerts, case history, and risk assessment were created as fictional practice records. The Dilisense no-match result was a name search I reported separately; it does not verify or dismiss the fictional internal alerts.

## What I checked

1. **Case intake:** Why the review was opened, who it was assigned to, and the current status.
2. **Customer and documents:** Profile details, name comparison, document verification status, and the address difference.
3. **Screening:** Two simulated PEP candidates, their identifiers, the recorded Dilisense search, and available adverse-media leads.
4. **Financial background:** Declared source of funds, expected activity, and a basic transaction summary.
5. **Risk and EDD:** Draft risk score, EDD status, and any approvals or checks still needed.
6. **Follow-up and QA:** Information requests, case activity, QA status, and basic data-link checks.

## Main findings

| Area | What I found |
|---|---|
| KYC review | Open; high case priority because of a PEP-flag review |
| Identity documents | Two simulated documents; passport verification still pending |
| Address | Customer profile and address-proof record do not match |
| PEP screening | Two simulated alerts; one has matching DOB and country, but identity is not confirmed |
| Dilisense | A separately recorded, user-reported name search returned no match |
| Adverse media | No records for this customer in the supplied training table |
| Source of funds | Declared as business fees; supporting verification is still needed |
| Customer risk | MEDIUM is only a draft training rating, not a final risk decision |
| EDD and requests | EDD in progress; three information requests are open |
| QA | Pending |

**My recommendation:** Keep the KYC review open. The address evidence, original PEP alert, and source-of-funds details need further review before an analyst can recommend closure. A PEP flag or a name match is not enough by itself to confirm a PEP, and a no-match search is not enough to clear an existing internal alert.

## Files

- [`sql/investigation.sql`](sql/investigation.sql) — My 22 read-only SQL queries.
- [`docs/case_report.md`](docs/case_report.md) — Findings, evidence gaps, and the recommended next action.
- [`docs/query_explanation.md`](docs/query_explanation.md) — What, why, and when for each SQL query.

## What I learned

This case helped me practise separating a recorded flag from a confirmed finding. I also learned to check what information is missing, document the limits of the evidence, and avoid closing a review just because one screening search returned no match.

The original transaction data does not state a currency. The additional financial profile uses **SCU (simulated currency units)**, so I have not compared their amounts directly.
