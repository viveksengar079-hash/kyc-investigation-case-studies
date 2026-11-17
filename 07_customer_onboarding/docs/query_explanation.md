# Query Explanation — Case Study 7

These are my notes for the 25 read-only queries in `sql/investigation.sql`. I kept the SQL straightforward so I can explain it during a junior KYC Analyst interview.

**Note:** The SQL shows what is in the simulated file. It does not authenticate a document, send an information request or approve an account.

## Application intake and applicant profile

### Query 1 — Review the new application

**What:** Read the assigned onboarding review and its key dates.

**Why:** I need to see what type of case this is, who owns it, and whether there is a deadline.

**When:** When a new case appears in the onboarding queue.

**What I found:** REV-02001: ONBOARDING, NEW_APPLICATION, opened 21 Oct 2026, due 20 Nov 2026, IN_PROGRESS, priority LOW.

### Query 2 — Check basic applicant information

**What:** Read the applicant type, country, sector and flags.

**Why:** It helps me understand whose identity must be checked and what initial risk context is recorded.

**When:** At the start of customer due diligence (CDD).

**What I found:** A synthetic Individual applicant from IN, sector Real Estate, sector risk Medium, PEP and sanctions flags 0.

### Query 3 — Review the applicant declaration

**What:** Read the applicant’s date of birth, occupation, address and application status.

**Why:** These details form the profile we compare with the submitted documents.

**When:** During the initial customer identification check.

**What I found:** Fictional applicant: DOB 4 Oct 1970, self-employed professional, declared address 11 Training Avenue, Indore, application pending, no relationship start date.

### Query 4 — Check whether an account has opened

**What:** Look at the applicant’s simulated account status.

**Why:** A pending account should not be described as an active banking relationship.

**When:** Before making an onboarding recommendation.

**What I found:** ACC-02001, PERSONAL, PENDING_OPEN; open_date is blank.

### Query 5 — Check the onboarding deadline

**What:** Calculate how many days remain to the simulated due date as at 18 Nov 2026.

**Why:** I need to know the time available to resolve outstanding verification before the case becomes overdue.

**When:** When planning follow-ups and prioritizing the queue.

**What I found:** Two days remain on the fixed reference date 18 Nov 2026; the review is not yet overdue.

## Identity and address checks

### Query 6 — List identity and address documents

**What:** Read the available document records and their current verification statuses.

**Why:** Having a document reference is not the same as verifying its authenticity.

**When:** During identity and address verification.

**What I found:** Passport and address-proof records both exist, but both are marked PENDING verification.

### Query 7 — Compare the names on documents

**What:** Check whether recorded document holder names match the customer name.

**Why:** A name difference may require explanation or additional proof; a match does not authenticate a document.

**When:** During document comparison.

**What I found:** Both names match in the training records; neither document has been verified.

### Query 8 — Check the passport expiry separately

**What:** Compare the stated passport expiry with our fixed reference date.

**Why:** An unexpired passport can still need authenticity and identity verification.

**When:** While reviewing identity-document sufficiency.

**What I found:** The passport expires in October 2029, so it is not expired on 18 Nov 2026; status is still PENDING.

### Query 9 — Compare declared and proof addresses

**What:** Check whether the recorded address proof shows the same address as the applicant declaration.

**Why:** Matching addresses remove one discrepancy, but do not prove the document was verified.

**When:** During address evidence checks.

**What I found:** Address fields match exactly; address-proof verification remains PENDING.

### Query 10 — Count pending document checks

**What:** Count how many of the applicant’s document records still require verification.

**Why:** This tells me whether it is possible to recommend onboarding as complete.

**When:** After reviewing all document records.

**What I found:** Two document records and two pending verifications.

## Financial profile

### Query 11 — Review stated income and expected activity

**What:** Read the applicant’s source of funds, occupation-related financial declaration, and expected activity.

**Why:** Expected activity is used to understand the relationship and set an initial risk profile.

**When:** During onboarding CDD and customer risk assessment.

**What I found:** Annual income 600,000 SCU, professional fees, wealth from employment income/savings, 15 expected monthly transactions, IN|SG counterparties, SELF_DECLARED.

### Query 12 — Check whether funding details are verified

**What:** Classify the financial information based on the status field.

**Why:** The existence of a declaration does not mean supporting financial evidence was checked.

**When:** When deciding whether further CDD evidence is needed under policy.

**What I found:** Financial background is SELF_DECLARED and classified as DECLARATION_ONLY; whether additional proof is required depends on risk and policy.

## Screening evidence

### Query 13 — Check the applicant screening indicators

**What:** Read the stored PEP and sanctions indicator values.

**Why:** Risk flags are useful context but are not a complete screening audit trail.

**When:** At the initial screening stage.

**What I found:** All listed source flags are 0; this is not proof that a screening search was performed.

### Query 14 — Look for screening-alert records

**What:** Read any simulated PEP or sanctions alerts linked to this applicant.

**Why:** A match requires investigation, but having no alert row does not prove the screening control ran.

**When:** When checking the screening evidence available before onboarding.

**What I found:** No alert rows recorded for this applicant in the synthetic pack; screening completion cannot be confirmed.

### Query 15 — Look for a logged screening search

**What:** Check whether a screening-platform search was recorded.

**Why:** I should not call screening completed if there is no trace of the check.

**When:** Before completing the onboarding screening checklist.

**What I found:** No screening-search log exists for applicant 2001.

### Query 16 — Look for an adverse-media record

**What:** Check if the training pack contains any adverse-media lead for the applicant.

**Why:** An absent record is different from documented negative media screening.

**When:** When reviewing background screening if required by policy.

**What I found:** No adverse-media row exists in the supplied data. No independent clearance was established.

## Risk, requests and QA

### Query 17 — Review the preliminary risk rating

**What:** Check the training risk assessment and its approval status.

**Why:** A preliminary score can support triage but does not approve the customer.

**When:** After initial CDD and available screening information are reviewed.

**What I found:** TRAINING_PRELIMINARY: simulated score 2 and proposed LOW. Sector risk is Medium. This is not a finalized bank risk rating.

### Query 18 — Check existing requests for information

**What:** See whether any document or clarification request has already been logged.

**Why:** I should avoid saying a request was sent when the record does not show one.

**When:** Before preparing a new request for pending verification.

**What I found:** No information request is recorded. A request/check can be proposed, but no contact can be claimed.

### Query 19 — Review the recorded case activity

**What:** Read the case event timeline.

**Why:** It tells me what happened so far and what is not documented.

**When:** Before preparing the analyst case note.

**What I found:** One CASE_OPENED event on 21 Oct 2026. No completed document or screening events are recorded.

### Query 20 — Review the open QA issue

**What:** Read any QA finding and its required correction.

**Why:** An unresolved verification defect can prevent completion even when a preliminary risk score is low.

**When:** Before submitting the file for quality approval.

**What I found:** QA-02001 on 17 Nov 2026 is OPEN_FINDING: MISSING_DOCUMENT_VERIFICATION; correction_required YES.

## Onboarding decision readiness

### Query 21 — Check whether transactions exist for the applicant

**What:** Count transactions in the original source file.

**Why:** This confirms we are not incorrectly treating a new applicant as an existing customer with account activity.

**When:** While confirming the application is an onboarding case.

**What I found:** Zero original transactions for the new applicant. Do not perform a historical TM review for this case.

### Query 22 — Check the application, account, risk and QA together

**What:** Show the key workflow statuses in one result.

**Why:** The analyst needs a final view before recommending whether onboarding can proceed.

**When:** At the end of the onboarding review.

**What I found:** Review IN_PROGRESS, account PENDING_OPEN, risk TRAINING_PRELIMINARY, QA OPEN_FINDING.

## Basic integrity checks

### Query 23 — Check document links

**What:** Count documents that have no matching customer record.

**Why:** Documents linked to the wrong customer should not be used in the decision.

**When:** During basic data quality checks.

**What I found:** Zero unmatched document records.

### Query 24 — Check risk-assessment links

**What:** Check that risk assessments are linked to the same client as their review.

**Why:** A risk rating from another customer file would make the case unreliable.

**When:** During final data quality checks.

**What I found:** Zero mismatched risk records.

### Query 25 — Check QA links

**What:** Make sure the QA finding belongs to the correct review and client.

**Why:** An analyst must not resolve or refer the wrong customer’s QA issue.

**When:** During final data quality checks.

**What I found:** Zero mismatched QA records.
