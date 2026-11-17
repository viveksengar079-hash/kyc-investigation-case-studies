# SQL query explanations — Case Study 2

I used simple queries to review the company, follow its ownership chain and check whether the KYB file is ready for closure.

**Note:** All ownership names and supporting records are simulated. Query results are evidence from the training database, not real external verification.

## 1. Assigned company review

**What I checked:** Assigned company review.
**Why:** See why this company was selected for KYB review.
**When:** Start of an assigned corporate KYB review.
**What I found:** The ownership-opacity review is in progress and has high operational priority. The review is due on 20 November 2026.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 2. Customer risk indicators

**What I checked:** Customer risk indicators.
**Why:** Understand source risk flags without assuming they are confirmed matches.
**When:** After retrieving the case.
**What I found:** The original record calls the business high sector risk, with a sectoral-sanctions indicator. This is not proof of a sanctions breach.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 3. Business registration details

**What I checked:** Business registration details.
**Why:** Check legal entity details and registration verification status.
**When:** Corporate due diligence.
**What I found:** The registration is recorded as pending verification.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 4. Company profile

**What I checked:** Company profile.
**Why:** Understand the recorded address and existing relationship.
**When:** Corporate due diligence.
**What I found:** The simulated business address is recorded, and the relationship is active.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 5. Documents in the file

**What I checked:** Documents in the file.
**Why:** Check which supporting records are present and verified.
**When:** Before recommending a KYB decision.
**What I found:** There are two document records: registration certificate pending and business address proof verified.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 6. Company name on documents

**What I checked:** Company name on documents.
**Why:** Identify name mismatches in the recorded evidence.
**When:** Document review.
**What I found:** The name on each document matches the simulated legal name exactly.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 7. Registered address versus proof

**What I checked:** Registered address versus proof.
**Why:** Compare the registered address to the available address evidence.
**When:** Document review.
**What I found:** The registered and proof addresses match in the training records.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 8. Direct owners of the company

**What I checked:** Direct owners of the company.
**Why:** Identify shareholders directly owning the client company.
**When:** Corporate ownership review.
**What I found:** The client is recorded as 60% owned by a holding company and 40% by one individual.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 9. Owners of the holding company

**What I checked:** Owners of the holding company.
**Why:** Identify the people behind the company shareholder.
**When:** When another entity appears in ownership records.
**What I found:** The holding company is split 50/50 between two individuals.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 10. Ownership totals at each level

**What I checked:** Ownership totals at each level.
**Why:** Check whether ownership percentages add up at each level.
**When:** Before relying on the ownership picture.
**What I found:** Both levels add up to 100%, but this only checks the math, not the authenticity of ownership.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 11. Direct individual shareholder

**What I checked:** Direct individual shareholder.
**Why:** Record the individual who directly owns 40% of the company.
**When:** UBO identification.
**What I found:** One individual directly owns 40%.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 12. Calculate indirect ownership

**What I checked:** Calculate indirect ownership.
**Why:** Calculate each indirect owner’s share using basic percentage multiplication.
**When:** When ownership passes through a holding company.
**What I found:** Each indirect individual owns 60% × 50% = 30%.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 13. Recorded beneficial owners

**What I checked:** Recorded beneficial owners.
**Why:** Compare our calculated stakes with the simulated UBO register.
**When:** After tracing ownership.
**What I found:** The beneficial-owner table lists 40%, 30%, and 30%. The indicator column uses a teaching threshold, not a banking rule.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 14. Unverified beneficial owners

**What I checked:** Unverified beneficial owners.
**Why:** Identify whose identity or ownership evidence remains pending.
**When:** Before closing UBO checks.
**What I found:** All three listed individuals still have pending identity/ownership verification.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 15. Recorded screening alerts

**What I checked:** Recorded screening alerts.
**Why:** Check whether the training pack contains screening alert records.
**When:** During KYB screening review; zero records do not prove clearance.
**What I found:** No screening alert records are linked to this client in the training pack. That does not mean the company or owners were cleared.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 16. Adverse-media leads in the pack

**What I checked:** Adverse-media leads in the pack.
**Why:** Check whether a media lead needs to be verified before making any claim.
**When:** When adverse-media information is present.
**What I found:** A fictional civil-dispute media lead requires review. It has not been independently verified.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 17. Declared financial background

**What I checked:** Declared financial background.
**Why:** Understand the claimed business funds and whether they have been verified.
**When:** Risk review and EDD.
**What I found:** The financial profile says business revenue and ownership earnings, but the funding information is unverified and amounts use simulated currency units.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 18. Draft customer risk assessment

**What I checked:** Draft customer risk assessment.
**Why:** Spot unresolved differences between high sector risk and draft overall risk rating.
**When:** During risk assessment.
**What I found:** The draft risk band says MEDIUM although sector risk is HIGH. I would ask for a proper risk-rating review, not accept the draft automatically.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 19. Enhanced due diligence status

**What I checked:** Enhanced due diligence status.
**Why:** Understand which enhanced checks are still incomplete.
**When:** When additional due diligence is required.
**What I found:** EDD is in progress, source-of-funds checks are required and management approval has not been requested.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 20. Requests for missing evidence

**What I checked:** Requests for missing evidence.
**Why:** Identify outstanding ownership documents and UBO identity requests.
**When:** When evidence is missing.
**What I found:** Two information requests are outstanding: holding-company ownership evidence and beneficial-owner IDs.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 21. Count overdue requests

**What I checked:** Count overdue requests.
**Why:** Measure unanswered requests already marked overdue.
**When:** During pending case follow-up.
**What I found:** Both requests are recorded as overdue; that is distinct from the overall review due date.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 22. Quality review findings

**What I checked:** Quality review findings.
**Why:** See whether QA found issues requiring correction.
**When:** Before submitting the review for closure.
**What I found:** QA has an open finding for incomplete UBO evidence.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 23. Case activity history

**What I checked:** Case activity history.
**Why:** Understand when the case was opened and information was requested.
**When:** Case management and audit review.
**What I found:** The case was opened and then supporting information was requested.

**SQL used:** `SELECT / WHERE` plus simple filters and sorting where needed.

## 24. Current case status

**What I checked:** Current case status.
**Why:** Check whether the file is ready for a final decision.
**When:** Before writing the investigation conclusion.
**What I found:** The KYB review is still in progress; risk assessment is draft and EDD is in progress.

**SQL used:** `JOIN` plus simple filters and sorting where needed.

## 25. Check ownership references

**What I checked:** Check ownership references.
**Why:** Make sure ownership links belong to a known client.
**When:** Quality check before relying on records.
**What I found:** No selected ownership links point to an unknown client.

**SQL used:** `JOIN` plus simple filters and sorting where needed.

## 26. Check UBO references

**What I checked:** Check UBO references.
**Why:** Make sure the UBO register belongs to a known client.
**When:** Quality check before relying on records.
**What I found:** No selected UBO records point to an unknown client.

**SQL used:** `JOIN` plus simple filters and sorting where needed.

