# Case Report — New Customer Onboarding

**Applicant:** Synthetic Applicant 2001  
**Client ID:** 2001  
**Review ID:** REV-02001  
**Review type:** ONBOARDING  
**Reference date:** 18 November 2026  
**Training case:** All customer evidence is simulated

## Case background

I reviewed a new individual applicant's file to see whether the required KYC checks were ready for onboarding. The review started on 21 October 2026 and is due on 20 November 2026. The recorded status is IN_PROGRESS. The account is marked PENDING_OPEN and has no open date, so I did not treat the customer as already onboarded.

## Identity and address checks

The dataset has a passport record and an address-proof record. Both have the applicant's recorded name, and the address in the address proof matches the declared address. The passport expiry date is 4 October 2029, which is in the future on the reference date.

**The problem:** both document records still say PENDING verification. A matching name or address does not mean the document has been authenticated. I would ask the verification team or assigned checker to complete and document these steps according to the institution's policy.

## Screening evidence

The customer risk flags show PEP = 0 and sanctions = 0, but I found no screening-search log or screening-alert row for Client 2001. I therefore cannot state that PEP and sanctions screening was completed or returned a no-match result. I would confirm the required screening check and keep its evidence in the case record before approval.

The dataset also has no adverse-media lead for this customer. That does not prove a negative adverse-media screening was completed.

## Financial background and risk

The applicant's simulated occupation is self-employed professional. The financial profile records professional fees as source of funds and employment income and savings as source of wealth. Annual income is 600,000 SCU, with an expected 15 transactions per month. **SCU is a synthetic unit, not INR.** The funding-information status is SELF_DECLARED.

The risk-assessment table proposes LOW, with a simulated score of 2, and marks it TRAINING_PRELIMINARY. Sector risk is recorded as Medium. I would not call the LOW band an approved customer risk rating. Additional checks should be based on the bank's actual risk-rating and CDD policy.

## Case follow-up and QA

One case-opening event is recorded. There is no information request in the dataset, so I cannot claim I contacted the applicant.

QA-02001, dated 17 November 2026, is OPEN_FINDING with the issue MISSING_DOCUMENT_VERIFICATION and correction required YES. This supports the need to finish the document checks before recommending completion.

As of 18 November 2026, there are two days remaining before the simulated review due date. The review is not overdue yet.

## My L1 recommendation

**Do not recommend activation at this stage. Keep the onboarding review in progress.**

I would recommend these next actions:

1. Complete and record passport and address-proof verification.
2. Confirm that the required PEP/sanctions screening was performed, and attach or record its result.
3. Resolve QA-02001 and document the correction.
4. Confirm the preliminary risk assessment under the company's risk-based policy.
5. Ask for additional customer information only where the policy and any resulting gaps require it.

I would then refer the completed file for the appropriate checker or approval step. I am not claiming to have approved or rejected the customer or to have contacted them.

**Recorded case status:** IN_PROGRESS.  
**My recommendation:** Keep onboarding pending until outstanding checks are completed.

## Scope and limitations

This is a portfolio exercise using fictional records. There are no actual identity document images or provider screening results for this applicant. All SQL queries were written to read data only. The case demonstrates how I would assess onboarding readiness, not that a real account was opened or a genuine financial-crime screening was completed.
