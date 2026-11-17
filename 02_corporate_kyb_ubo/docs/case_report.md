# Case Study 2 — Corporate KYB and UBO Investigation

**Client ID:** 121  
**Customer:** Phillips PLC  
**Review ID:** REV-00121  
**Review type:** Event-driven corporate KYB  
**Case status:** IN_PROGRESS  
**Data:** Original Kaggle customer profile plus fictional supporting KYB evidence

## Why I reviewed this company

I worked through a simulated KYB file for an existing corporate customer. The assigned review was triggered by an ownership-opacity indicator. My main goal was to find who owns the business, follow the indirect ownership chain and check whether the evidence is good enough to finish the review.

## Customer and company details

Phillips PLC is marked as a corporate customer in India, in the **Defense/Arms** sector. The original dataset rates the sector risk as **High**, records a sectoral-sanctions flag of **1** and gives an ownership-opacity score of **1.0**. These are risk indicators from the data, not confirmed sanctions findings.

The generated company record has registration number **SIM-REG-00121**, but registration verification is marked **PENDING**. Of the two simulated supporting documents, the incorporation certificate is pending verification. The business address proof is marked verified, and its address matches the recorded company address. These checks do not establish that a real company has been verified.

## Ownership review

I started with the direct owners of Phillips PLC:

| Direct owner | Share in Phillips PLC | Status |
|---|---:|---|
| Synthetic Holding Company 121 | 60% | Pending evidence |
| Synthetic Beneficiary 121-3 | 40% | Pending evidence |

The holding company is owned by two individuals, each with a 50% stake. I used simple multiplication to work out their indirect ownership:

| Individual | Ownership route | Effective interest | Verification |
|---|---|---:|---|
| Synthetic Beneficiary 121-1 | 60% × 50% | 30% | PENDING |
| Synthetic Beneficiary 121-2 | 60% × 50% | 30% | PENDING |
| Synthetic Beneficiary 121-3 | Direct | 40% | PENDING |
| **Total** | | **100%** | |

Both levels of the ownership structure add up to 100%. This supports the arithmetic, but does not independently verify who controls the company, whether nominee arrangements exist, or whether the shareholder register is genuine.

The generated `ubo_25pct_indicator` is a **training field only**. In India, the RBI Commercial Banks KYC Directions, 2025 define company controlling ownership interest as **more than 10%**, and control can also arise through other means. All three recorded individuals exceed that ownership threshold, but we still need to verify their identities and any control rights. [RBI official directions](https://www.rbi.org.in/Scripts/BS_ViewMasDirections.aspx?id=13141).

## Screening and financial-risk observations

The original customer record has no individual PEP or broad sanctions flag, but it does have a **sectoral-sanctions flag**. I would clarify what this particular dataset flag means and carry out the screening checks required by the bank's policy, including the company and relevant owners. No linked screening alert rows appear for this customer in the training pack. That does **not** mean screening was completed or cleared.

The training pack also contains an unverified, fictional adverse-media item describing a civil dispute. It requires checking, not an automatic negative conclusion.

The generated financial profile lists annual revenue of **240,000 SCU** and business revenue as source of funds. The funding status is **UNVERIFIED**. SCU means simulated currency units, not INR or USD.

## Risk review and EDD

The generated draft risk score is **4**, with a proposed **MEDIUM** band. I would not treat that as approved. The business has High sector risk, an ownership-opacity concern, a sectoral-sanctions indicator, and incomplete registration and UBO evidence. I would refer the draft for a more complete risk review under the bank's policy.

The EDD record is marked **IN_PROGRESS**. Source-of-funds verification is required, source-of-wealth verification is pending, and management approval has not been requested. EDD should not be treated as complete.

## Information requests and quality review

There are two outstanding simulated requests, both marked **OVERDUE** with due date **1 November 2026**:

- Verify the holding company's ownership evidence.
- Verify the identities of the three beneficial owners.

The QA record also has an **OPEN_FINDING** for incomplete UBO evidence. The main KYB review has a later due date, **20 November 2026**, and is still marked `IN_PROGRESS`. An overdue document request does not automatically mean the whole review is overdue.

## My recommendation

I would **keep this KYB review in progress**, follow up on both outstanding requests, verify the company registration and ownership supporting records, and complete the required screening and financial checks. The draft customer risk rating needs reassessment, especially given the high-risk sector and unresolved ownership evidence.

Once the information is available, I would update the case notes and refer it for any required senior review, approval or escalation. I would not mark the UBO identities verified or close the case based only on these synthetic database entries.

**Working outcome:** KYB incomplete — follow-up and risk review required.

## What I learned

This case helped me practice following a two-level company ownership structure, calculating effective holdings, checking document gaps and writing a reasoned L1 KYB recommendation. I used MySQL for the record checks and simple calculations; the main value is being able to explain why the business cannot yet be cleared.

*All supporting company and identity evidence is synthetic. This project is a training exercise, not a real bank investigation.*
