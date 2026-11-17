# Case Study 4 — Periodic KYC Review and EDD Assessment

**Review:** REV-00036  
**Client ID:** 36  
**Customer:** Olson, Evans and Thomas  
**Review type:** Periodic KYC  
**Reference date:** 18 November 2026  
**Status in the training dataset:** PENDING_CUSTOMER

## Why I reviewed this case

This is a fictional periodic KYC case that was due on 15 October 2026. My job in the exercise was to find out why the review was still pending, whether the customer documents were usable, what information was outstanding, and whether the draft risk rating and EDD requirement needed another look.

The customer details in `clients_master` came from the original synthetic dataset. Document records, review dates, financial declarations, requests, QA findings and risk scores are extra **simulated training data**. This is not a real bank case.

## 1. Case intake and review age

The review `REV-00036` was opened on 15 September 2026 and is marked `PENDING_CUSTOMER`. Its due date was 15 October 2026, which makes it **34 days overdue** on our reference date. It has HIGH case priority. That is an operational priority, not the final customer risk rating.

## 2. Customer profile

The record classifies this customer as an **Individual in India**, connected to the **Crypto Exchange** sector, with **High sector risk**. Its simulated occupation is **Consultant**. The name resembles a company name even though the customer type is Individual. I would clarify the customer's legal identity and how the occupation relates to the stated sector; I would not silently change the source data.

The original PEP and sanctions flags are both zero, but that does not prove that a fresh screening search has been completed or cleared for this review.

## 3. Documents and address

The generated file has two document records:

| Record | Recorded status | My assessment |
|---|---|---|
| Passport | VERIFIED; expiry **10 January 2028** | Not expired as of 18 November 2026 |
| Address proof | VERIFIED; no expiry date recorded | Profile address and proof address match in the training records |

Both document holder names match the customer name in the dataset. These are **simulated** verification statuses, not real document authentication.

**Key inconsistency:** There is an overdue request to "Refresh identity record" even though the passport is marked verified and not expired. I would check the previous KYC evidence, applicable refresh requirements and the reason for the request before concluding that a new passport is necessary. The requested refresh could relate to a policy requirement or another issue not represented in the data.

## 4. Outstanding request and delays

There is one request, `REQ-00036-01`, marked `OVERDUE`.

- Requested: **21 October 2026**
- Request due: **1 November 2026**
- Days overdue on 18 November: **17**
- Request raised **6 days after** the KYC review due date

The case events show case opening and the information request, but no recorded customer response or completion event. I would follow up and document the reason for the delay rather than assume the customer refused to cooperate.

## 5. Financial profile and customer risk

The simulated financial profile shows salary as the source of funds, employment income and savings as the source of wealth, and expected activity involving India and Singapore. The amounts are in **SCU (synthetic currency units)** and are self-declared; I have not treated them as rupees or verified income.

The recorded sector risk is High, while the simulated overall customer risk assessment proposes **MEDIUM**, with status `DRAFT_PENDING_REVIEW`. That is not automatically wrong: a sector factor is not the whole customer rating. But there must be an explanation for how the proposed rating was reached, especially where the customer type and sector information need clarification. I would refer the scoring rationale for review rather than approve it.

## 6. Screening and EDD

No screening-alert record was returned for Client 36 in the generated pack. This means I found no *recorded alert in these tables*, **not** that sanctions or PEP screening is cleared.

No EDD record was returned. I therefore cannot claim EDD was completed, rejected or formally waived. Because the sector is high-risk in the source data and the customer description needs clarification, I would ask the responsible reviewer whether enhanced due diligence is required under the firm's policy. If required, I would obtain and verify additional supporting information, including source-of-funds evidence where relevant.

## 7. Quality assurance finding

QA record `QA-00036` is an `OPEN_FINDING`, with reason `OVERDUE_INFORMATION_REQUEST` and correction required `YES`.

The case is not ready to be called complete in this exercise. The QA item and delayed information request must be addressed, and the pending draft risk assessment should be reviewed.

## 8. My L1 recommendation

**Keep the periodic KYC review pending and prioritize follow-up.** My next actions would be to:

1. Confirm why an identity refresh was requested despite the verified, unexpired passport record.
2. Obtain the customer's response or document the follow-up and any escalation needed under policy.
3. Clarify the Individual classification, name and relationship to the Crypto Exchange sector.
4. Ask for review of the draft MEDIUM rating against the High sector risk and other evidence.
5. Refer EDD applicability to the appropriate compliance/risk reviewer, because no EDD decision is on record.
6. Resolve the open QA finding before recommending closure.

I would not independently approve or close this case as an L1 analyst while the information request and QA finding remain open.

## Data limitations

- The supplementary evidence is synthetic and does not prove a real customer passed identity checks.
- An absence of alerts or EDD rows is **not** evidence that screening or EDD was completed.
- SCU amounts are fictional units and should not be compared directly with the original transaction amounts.
- The fixed date is used only to make the exercise reproducible; elapsed days change in a live workflow.
- This is a portfolio investigation, not professional bank employment.
