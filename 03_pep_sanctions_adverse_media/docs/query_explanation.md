# Query explanations — Case Study 3

I worked through the screening case in the same order I would review an alert: understand the customer, check the alert and identifiers, look at media evidence, and then document the next action. These are fictional records for practice, not verified screening results.

The reference date used for document expiry and overdue calculations is **18 November 2026**.

## 1. Assigned screening review

**What:** Find the review assigned to the screening analyst.

**Why:** Confirm why the case was raised and whether it is waiting for action.

**When:** As soon as the screening case reaches the analyst queue.

**What I found:** Event-driven PEP review, high priority, PENDING_CUSTOMER. The review was due on 10 November 2026.

## 2. Customer risk flags

**What:** Check the basic customer record and its existing risk flags.

**Why:** Know whose name we are investigating and avoid confusing a flag with a confirmed match.

**When:** Immediately after checking the assigned review.

**What I found:** Hoffman-Frost is an individual from Japan in Import/Export; PEP flag 1, sanctions flag 0, Medium sector risk.

## 3. Customer identity details

**What:** Get DOB, country, occupation and current relationship status.

**Why:** These identifiers help compare watchlist candidates with the actual customer.

**When:** Before interpreting a screening name match.

**What I found:** Simulated date of birth 18 June 1992, country JP, occupation small business owner; active relationship.

## 4. Available KYC documents

**What:** List the documents included in the training case.

**Why:** A screening review may expose KYC document gaps that should be noted and referred to the right team.

**When:** During evidence inventory and customer identity checks.

**What I found:** Two simulated records: passport EXPIRED and address proof VERIFIED.

## 5. Name on each document

**What:** Compare the exact stored names in the customer and document rows.

**Why:** Spot obvious differences that might affect identity verification.

**When:** After pulling the documents into the case.

**What I found:** Both fictional document-name strings match the stored customer name. This does not authenticate documents.

## 6. Passport expiry check

**What:** Check the stated expiry date against a fixed training review date.

**Why:** Identify documents that should not be treated as current identity evidence.

**When:** When checking document validity during KYC review.

**What I found:** The passport expired 1 March 2025; the address proof has no expiry date recorded. Its verification is a separate field.

## 7. Address evidence consistency

**What:** Compare the fictional recorded address with the address-proof entry.

**Why:** Distinguish address discrepancies from unrelated screening concerns.

**When:** During CDD evidence review when proof is available.

**What I found:** The simulated recorded address matches the proof entry; this is a table consistency check, not real-world confirmation.

## 8. PEP screening alert details

**What:** Read the underlying alert before choosing a disposition.

**Why:** A PEP flag alone is not enough to determine who matched or what evidence exists.

**When:** When a PEP screening alert is assigned.

**What I found:** One fictional PEP alert, SCR-00028. High name similarity, OPEN, and REFER_FOR_VERIFICATION; the political position is only “Simulated risk record”.

## 9. Compare screening identifiers

**What:** Compare the name, date of birth and country across the two fictional records.

**Why:** Stronger identifier agreement makes an alert important, but still cannot verify the political office or screening source.

**When:** During L1 screening match analysis.

**What I found:** Name, DOB and country match exactly in the generated data; this remains a potential match, not a proven PEP.

## 10. Alert recommendation and origin

**What:** Check what the alert system recommends and where the record came from.

**Why:** Do not present an internal training recommendation as an independent compliance confirmation.

**When:** Before proposing a screening disposition.

**What I found:** The source is SIMULATED_INTERNAL_WATCHLIST, record origin SIMULATED_TRAINING and recommendation REFER_FOR_VERIFICATION.

## 11. Check recorded sanctions alerts

**What:** Look for sanctions alerts in the supplied training case.

**Why:** PEP screening and sanctions screening are different checks.

**When:** During sanctions-screening record review.

**What I found:** No sanctions alert rows for this client. This does not prove sanctions screening was performed or cleared.

## 12. Check external screening search logs

**What:** Check whether a real provider search is logged for this customer.

**Why:** A generated internal alert must not be confused with a documented external search.

**When:** Before claiming any provider verification.

**What I found:** No external screening-search log exists for Client 341. The Dilisense search for Client 1708 belongs to Case 1, not here.

## 13. Read the adverse-media lead

**What:** Open the media lead attached to the screening case.

**Why:** Find out what is alleged and why the record requires attention.

**When:** When a potential adverse-media hit appears.

**What I found:** One fictional news lead alleges a business licensing issue; its disposition is REVIEW_REQUIRED.

## 14. Check media verification status

**What:** Check whether the media record has independent evidence or a usable source link.

**Why:** A name-only match from fictional news cannot support a factual wrongdoing allegation.

**When:** Before relying on adverse media in customer risk assessment.

**What I found:** Name-match-only YES, blank URL, verification NOT_VERIFIED and origin SIMULATED_TRAINING. Do not treat the allegation as true.

## 15. Financial background context

**What:** Read the customer’s declared source-of-funds and expected-activity fields.

**Why:** Identify incomplete background information if enhanced review becomes necessary.

**When:** During supporting CDD or risk assessment, not full transaction monitoring.

**What I found:** Simulated professional fees and inheritance/investments; funding UNVERIFIED. Values are SCU training units, not money in INR or JPY.

## 16. Draft customer risk assessment

**What:** Check the current risk score and whether it is approved.

**Why:** A draft risk label must not be presented as an accepted bank decision.

**When:** Once screening and CDD evidence are being assessed.

**What I found:** Training score 4 with draft MEDIUM band and DRAFT_PENDING_REVIEW. The result is not a final approved rating.

## 17. Enhanced due diligence record

**What:** Check whether the case already has an EDD workflow entry.

**Why:** Avoid saying EDD is complete or underway without evidence.

**When:** When screening findings may warrant further risk-based checks.

**What I found:** No EDD row is attached in the training pack. If PEP exposure is substantiated, refer for applicable EDD under policy.

## 18. Outstanding information request

**What:** Identify what evidence was requested and whether it has arrived.

**Why:** Outstanding evidence may prevent a screening decision.

**When:** During case follow-up.

**What I found:** One PEP_SUPPORT request is OVERDUE; due date 1 November 2026.

## 19. How long the request is overdue

**What:** Calculate how many days have passed since the request deadline.

**Why:** Helps decide whether to follow up or raise a service-level concern.

**When:** During work-queue and overdue-case management.

**What I found:** The evidence request is 17 days past due as of 18 November 2026. This is a fixed reference date for consistent practice.

## 20. Case action history

**What:** Read the case activity trail.

**Why:** Make sure requested actions are recorded and do not repeat work.

**When:** Before preparing a summary or following up.

**What I found:** Two simulated events: case opened on 10 October and information requested on 21 October 2026.

## 21. QA review records

**What:** Check whether a separate QA review was logged.

**Why:** A missing QA row cannot be described as a QA pass.

**When:** Before final handoff or closure recommendation.

**What I found:** No QA review record exists in the pack for this client.

## 22. Case status before recommendation

**What:** Summarize the live case status alongside the proposed risk rating.

**Why:** Prevent a premature decision while the file is waiting on evidence.

**When:** Just before writing the L1 recommendation.

**What I found:** PENDING_CUSTOMER with a draft MEDIUM risk band. Review due date passed 10 November 2026.

## 23. Check the screening alert link

**What:** Check that the PEP alert belongs to the right review and customer.

**Why:** Avoid reviewing an alert mistakenly linked to another client.

**When:** During dataset quality checks before documenting findings.

**What I found:** Expected zero unmatched screening alerts.

## 24. Check the document link

**What:** Check the document records against the customer master.

**Why:** Make sure we do not use evidence tied to an unknown customer.

**When:** As a basic dataset integrity check.

**What I found:** Expected zero unmatched documents.
