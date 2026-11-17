# Case Study 5 — KYC Remediation and Document Exceptions

**Review ID:** REV-01085  
**Client ID:** 1085  
**Customer:** Grant, Smith and Hinton  
**Review type:** Periodic KYC review  
**Status:** IN_PROGRESS  
**Review date used for the exercise:** 18 November 2026

## Why I reviewed this case

I worked on a synthetic customer file where an identity document was expired and the document-refresh request was overdue. I wanted to find out what was missing, check what had already been verified, and make a clear recommendation for the next action. I used MySQL to read the case records and kept the investigation focused on KYC remediation, not transaction monitoring.

## What I checked

I started with the review assignment and customer profile. Then I checked the passport, address proof, document names, the information request, the case event history, the draft risk assessment and the QA record. I finished with simple checks to make sure the documents and requests were linked to the right customer.

## Main findings

| Area | Finding |
|---|---|
| Customer | The original synthetic record classifies the customer as an individual in India, associated with Energy/Oil. The company-style name is a source-data limitation, not a proven classification error. |
| KYC review | Periodic review, opened 6 October 2026; due 5 November 2026; still IN_PROGRESS and 13 days overdue on the reference date. |
| Passport | Simulated passport record expired on 1 March 2025. Its verification status is EXPIRED. |
| Address proof | Simulated address proof is marked VERIFIED and its address matches the recorded customer address. |
| Document names | Both recorded holder names match the customer name. A name match is not the same as document authentication. |
| Information request | Document refresh requested on 21 October 2026, due 1 November 2026; status OVERDUE with no recorded response. It is 17 days overdue. |
| Follow-up history | Events show case opening and information requested. No later response or reminder is recorded in the supplied history. |
| Screening | No screening alert row for this customer. This cannot be treated as evidence that screening was completed or cleared. |
| Sector and risk | Sector risk is High; sectoral-sanctions indicator is 1; overall training risk proposal is draft MEDIUM. The difference needs a policy-based review, not an automatic override. |
| Financial information | Source-of-funds details are marked SELF_DECLARED and have not been independently verified in this dataset. |
| EDD | No EDD record exists for this customer. This is not proof that EDD has been completed or is unnecessary. |
| QA | QA entry is PENDING, but there is no specific finding and correction_required is NO. I would not describe this as a confirmed QA defect. |

## My assessment

The passport is the main document exception. The customer file includes an address proof that is already marked verified, so I would not request another address document without a specific reason. The document-refresh request has passed its deadline and the KYC review is also overdue.

I would check the existing request notes and follow up through the authorized customer or relationship-management channel. I would ask for an acceptable, currently valid identity document in line with the bank's policy. I would record the contact attempt and revised expected response date, if applicable. If the delay continued, I would refer it to my supervisor using the bank's escalation process.

The High sector-risk indicator and sectoral-sanctions flag also deserve separate review. They are not proof of a sanctions match, and the training risk score cannot replace a bank-approved customer risk assessment. I would seek a review of the draft rating and confirm whether any further screening or EDD checks are required under policy.

## Recommendation

**Keep the KYC review open.** Do not mark the document exception resolved until acceptable replacement identity evidence has been received and verified. Follow up on the overdue request, update the case tracker accurately, and send the draft-risk questions to the appropriate reviewer. The QA record should be checked before final completion, but it does not currently document a specific defect.

## Limits of this case

All customer names and risk flags come from an original synthetic Kaggle dataset. Passport, address, request history, financial background, review dates and QA entries were added as simulated training records. I did not contact a real customer, authenticate a real passport, confirm a sanctions match, or approve a banking KYC review. The file remains open in this simulated exercise.
