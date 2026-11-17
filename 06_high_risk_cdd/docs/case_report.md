# Case Study 6 — High-Risk CDD and EDD Investigation

**Client:** 1877 — Smith-Wright  
**Review ID:** REV-01877  
**Case type:** Periodic KYC, high-risk evidence review  
**Review status:** OPEN  
**Reference date:** 18 November 2026

## 1. Why I reviewed this customer

This case is part of the revised KYC-only portfolio. The earlier synthetic pack's `case_study_index.csv` uses its own `CS06` number for a different case, so I use the actual `REV-01877` review and related evidence as my starting point.

The customer has a High sector-risk indicator, a PEP flag, and a draft HIGH customer risk assessment. The recorded EDD review has not started. My aim was to check what financial background information was on file and what further evidence would be needed before an appropriate reviewer could finish the KYC assessment.

This is a **synthetic training case**. The review is a scheduled periodic KYC review; the source does not say it was opened specifically because of a newly detected PEP alert.

## 2. Customer background

The original customer record describes Smith-Wright as an Individual in VE with a Crypto Exchange sector, sector risk High, and a PEP indicator of 1. It has a sanctions flag of 0 and an OFAC-country flag of 1. These are source-data indicators, **not confirmed sanctions findings**.

The simulated personal profile lists the occupation as Small business owner and the relationship as active. I would ask how the declared work connects with the crypto-exchange sector instead of assuming the classification is correct or incorrect.

The simulated passport and address-proof records are both marked VERIFIED. That helps with basic identity checks, but **it does not verify the origin of the customer's money or wealth**.

## 3. Screening background

The generated screening table contains one open PEP candidate with matching date of birth and country. The candidate position says *Simulated risk record* and does not establish a genuine political role. The alert recommendation is to refer it for verification.

I would obtain the original match source, a reliable description of the public role and other relevant identifiers before recording any true-match or false-positive disposition. The pack has no adverse-media row for this client; I would not describe that as a real adverse-media clearance.

## 4. Source of funds vs source of wealth

**Source of funds** is the origin of the money involved in the relevant activity. The financial profile states **Professional fees**.

**Source of wealth** is how the customer built their wider financial position over time. The profile states **Inheritance and investments**.

Both are recorded as `SELF_DECLARED`. The pack does not provide the bank statements, professional contracts, tax information, inheritance evidence or investment statements needed to verify these claims. The right action is to identify suitable supporting information according to the bank's policy and the risk involved, not to assume that the declarations are fraudulent.

The training record also states annual income of **90,000 SCU**, expected monthly activity value of **10,000 SCU**, expected five transactions per month and expected counterparty countries **VE|IN**. SCU is a synthetic unit and the original transaction file does not contain a currency, so I would **not compare the transaction value directly with SCU figures**.

## 5. Limited activity review

The original transaction file contains **28** records for this client across July–September 2025, with a recorded total of **159,379.03** in an unspecified currency. Monthly transaction counts were **8, 11 and 9**, which are above the simulated expected frequency of five a month. Only one record involves a counterparty country in the declared **VE|IN** list; the other **27** involve countries outside that list.

There are **four rapid-movement flags**, but the dataset does not provide the monitoring rules or proof of rapid fund movement. I would record the inconsistency for clarification and refer any specialist transaction alert to the TM team if appropriate. These records do not establish money laundering.

## 6. Risk assessment and EDD status

The generated risk assessment proposes **HIGH**, with a training score of **5**, but its status is `DRAFT_PENDING_REVIEW`. This is not an approved customer rating or an official bank score.

The EDD review is `NOT_STARTED`. Source-of-funds and source-of-wealth verification are only recorded as `DECLARATION_RECORDED`, and management approval is `NOT_REQUESTED`.

The periodic review has been OPEN since **14 October 2026**, was due **13 November 2026**, and was **five days past due** as of the fixed reference date. No information request or QA assessment is recorded for this client in the provided pack. Those absent rows must not be described as evidence that customer requests were completed or QA passed.

## 7. What I would request or clarify

- Clarification of the customer's actual business activity and the link to the Crypto Exchange sector.
- Appropriate supporting information for professional-fees income, such as invoices/contracts or payment evidence, where relevant and permitted by policy.
- Appropriate evidence supporting the claimed inheritance and investments, such as inheritance or investment records, depending on the bank's standards.
- Reliable evidence to confirm or dismiss the simulated PEP candidate, including the political role and identifying details.
- An explanation of the difference between the expected activity profile and the recorded international transaction frequency and countries, if relevant to the risk-based review.

These are **proposed information requests**, not requests already sent by a bank.

## 8. My L1 recommendation

**Keep the KYC review open.** I would refer the unresolved PEP screening result, start the appropriate EDD evidence collection under bank procedures, review the draft risk rating, and follow up on the overdue review. A final rating or required management approval must come from the authorized reviewer. I would not approve or reject the customer on the basis of this training record alone.

## 9. What I learned

This case taught me not to confuse an income declaration with proof of income, or a source-of-wealth declaration with a verified wealth history. It also reinforced that a High draft rating, a PEP flag and monitoring flags are reasons to investigate, not findings of wrongdoing.

**Evidence note:** Customer sector and flags are from the original synthetic source. Financial and KYC evidence is newly simulated; transaction history is from the original synthetic CSV. No genuine bank approval or independent PEP confirmation occurred.
