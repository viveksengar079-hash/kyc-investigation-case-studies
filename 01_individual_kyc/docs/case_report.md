# Case Report — Individual KYC Review

**Training case:** REV-01708  
**Client ID:** 1708  
**Customer:** Burton-Acosta  
**Review type:** EVENT_DRIVEN  
**Reason for review:** PEP_FLAG_REVIEW  
**Case opened:** 10 November 2026  
**Due date:** 10 December 2026  
**Assigned analyst in the simulated record:** ANL-009  
**Case status:** OPEN

> This report is based on synthetic customer information and fictional supporting KYC records. It is a portfolio exercise, not a real customer investigation or an actual bank compliance decision.

## 1. Why I reviewed this customer

The customer's original record has a PEP flag. In the training case, this resulted in an event-driven KYC review. I needed to check the customer's identity information, understand the screening alert, look at the available financial details, and see what was still missing before a decision could be made.

The review has **HIGH operational priority**, but that does not mean the customer has been confirmed as high risk.

## 2. Customer information

| Item | Finding |
|---|---|
| Customer type | Individual |
| Country | India (IN) |
| Sector | Real Estate |
| Sector risk | Medium |
| PEP flag | 1 |
| Sanctions flag | 0 |
| Date of birth | 14 June 1991 — simulated profile |
| Occupation | Real estate consultant — simulated profile |
| Relationship status | ACTIVE — simulated profile |

The sector risk is only one part of customer risk assessment. It is not the final customer risk rating. The sanctions flag being zero also does not replace a properly documented sanctions screening review.

## 3. Identity and address review

The generated KYC evidence contains two documents:

| Document | Recorded status | What I noted |
|---|---|---|
| Passport | PENDING | The name matches the customer profile, but verification is not complete |
| Address proof | REQUIRES_CLARIFICATION | The address does not match the recorded customer address |

The customer profile lists **42 Example Nagar, Indore (fictional)**, while the address proof lists **18 Sample Road, Indore (fictional)**.

My SQL name comparison returned `NAME_MATCH` for both document records. That confirms the names in these fields agree; it does **not** confirm that the documents are genuine or that identification is complete.

**What I would do next:** Keep address verification pending, ask the customer to confirm their current address, and follow the bank's policy for acceptable evidence or verification. I would not treat a different address as fraud without further checks.

## 4. PEP screening review

The simulated screening table contains two open PEP candidates:

| Alert | Identifier check | Initial view |
|---|---|---|
| SCR-00140 | DOB and country match the simulated customer profile | Stronger potential match; refer for verification |
| SCR-00141 | DOB and country differ | Likely false positive, but still open in the case data |

Both records are from a **simulated internal watchlist**. Neither is a confirmed real-person match.

A separate Dilisense search log records a name search for `Burton-Acosta` on 17 November 2026 with `NO_MATCH_FOUND`. The evidence field says `USER_REPORTED_NOT_INDEPENDENTLY_VERIFIED`.

I would not use that result to dismiss the fictional internal alerts. I would ask for the original alert source and more reliable identifiers before recommending a final disposition, especially for SCR-00140. There are no adverse-media rows for this customer in the provided training table; that is not proof that no adverse media exists elsewhere.

## 5. Financial background and customer activity

The simulated financial profile records:

- Declared source of funds: **Business fees**.
- Declared source of wealth: **Professional income and savings**.
- Annual income: **95,000 SCU**.
- Expected monthly transaction value: **15,000 SCU**.
- Expected monthly transaction count: **4**.
- Expected counterparty countries: **IN and AE**.
- Funding information status: **UNVERIFIED**.

The original transaction file shows **28 transactions** between 3 July and 24 September 2025, with a total recorded amount of **209,711.58** in unspecified units. **25 of 28** transactions involve foreign counterparties.

I reviewed these records only as background for the customer's KYC profile. The original transaction amounts have **no stated currency**, whereas SCU is a unit created for the simulation. I cannot make a valid amount-to-amount comparison between them. The foreign activity may be worth clarifying against the customer's declared expected activity, but it is not enough by itself to label the transactions suspicious.

## 6. Risk assessment and EDD

The training risk assessment shows:

| Item | Recorded result |
|---|---|
| Simulated risk score | 4 |
| Proposed risk band | MEDIUM |
| Assessment status | DRAFT_PENDING_REVIEW |
| Scoring method | TRAINING_RULES_NOT_BANK_POLICY |
| EDD status | IN_PROGRESS |
| Source-of-funds verification | REQUIRED |
| Source-of-wealth verification | PENDING |
| Management approval | NOT_REQUESTED |

I would not present the proposed MEDIUM rating as an approved outcome. The source-of-funds records still need checking, and the PEP screening question has not been resolved. Whether EDD or management approval is required depends on the final evidence and the bank's applicable policy.

## 7. Outstanding information requests

Three simulated requests are still open:

| Request | Reason | Due date | Status |
|---|---|---|---|
| CURRENT_ADDRESS | Clarify the address mismatch | 28 Nov 2026 | OPEN |
| ORIGINAL_PEP_ALERT | Obtain the source record for the PEP indicator | 28 Nov 2026 | OPEN |
| SOURCE_OF_FUNDS | Request explanation and supporting records | 28 Nov 2026 | OPEN |

The case history includes `CASE_OPENED` and `INFORMATION_REQUESTED`. The QA record is still **PENDING**. Nothing in these records shows that the case has been approved or closed.

## 8. My conclusion and recommended action

**Recommendation: Keep the review open and continue the evidence checks.**

Before recommending closure, I would:

1. Resolve the recorded address difference using suitable evidence and the bank's verification process.
2. Obtain the original PEP alert and compare reliable identifiers. SCR-00140 needs closer attention because the DOB and country match the training profile.
3. Check the source-of-funds explanation and supporting records.
4. Revisit the draft customer risk rating and EDD requirements after the information is received.
5. Document the outcome and refer any unresolved concerns to the appropriate reviewer or compliance team.

**Final status in the dataset: OPEN.** The risk assessment remains a draft, EDD remains in progress, and QA remains pending. I have not treated the absence of a final decision as a failure of the case study; identifying and documenting what is still needed is part of the exercise.

## 9. Evidence and limitations

- **Original Kaggle data:** Customer identity label, customer type, sector, country, risk flags, and historical transaction records.
- **Simulated additions:** Date of birth, occupation, addresses, documents, screening candidates, case history, financial declarations, risk assessment, EDD, requests and QA.
- **Reported external search:** Dilisense no-match result; recorded separately and not independently verified in this project.
- **Data checks:** My SQL checks found no document records linked to an unknown customer and no screening alerts linked to the wrong review for Client 1708. These checks do not prove the documents or screening findings are correct.

**Tools used:** MySQL Workbench for record review, Excel for case tracking, and Markdown for investigation notes.
