# Case Study 4 — SQL Query Explanations

These notes explain my SQL investigation in the same order as `sql/investigation.sql`. Every query uses a fixed customer ID and I used **18 November 2026** for overdue calculations. The data is simulated.

A periodic KYC refresh checks whether an existing customer’s information is still reliable and whether an updated risk review is needed. It is not the same as investigating a transaction alert.

## Query 1 — Check the assigned periodic review

**What:** See which review is assigned, why it was created, and its deadline.

**Why:** Start with the correct case before checking documents.

**When:** At the beginning of a periodic KYC review.

**How I used SQL:** I joined the review with the master customer record using `client_id`. That gives me the case and the customer name in the same row.

**Expected result:**

| review_id | client_name | review_type | trigger | opened_date | due_date | status | review_priority |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REV-00036 | Olson, Evans and Thomas | PERIODIC | SCHEDULED_REVIEW | 2026-09-15 | 2026-10-15 | PENDING_CUSTOMER | HIGH |


## Query 2 — Review the customer risk flags

**What:** Read basic customer classification and original risk indicators.

**Why:** Identify the areas that may need clarification or added checks.

**When:** During the initial customer-profile review.

**How I used SQL:** I filtered `clients_master` by `client_id = 36`. This is where I found the High sector risk and the zero PEP/sanctions flags.

**Expected result:**

| client_id | client_name | client_type | country | sector | sector_risk | pep_flag | sanctions_flag |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 36 | Olson, Evans and Thomas | Individual | IN | Crypto Exchange | High | 0 | 0 |


## Query 3 — Read the current customer profile

**What:** Check the profile on file, including occupation and address.

**Why:** Make sure the review is based on the right customer information.

**When:** Before deciding what details to refresh.

**How I used SQL:** I pulled the existing profile details. The occupation is Consultant and the relationship is marked ACTIVE.

**Expected result:**

| client_id | date_of_birth | occupation | registered_address | relationship_start_date | relationship_status |
| --- | --- | --- | --- | --- | --- |
| 36 | 1977-01-10 | Consultant | 46 Training Avenue, Indore (fictional) | 2024-02-06 | ACTIVE |


## Query 4 — Check how overdue the periodic review is

**What:** Calculate the days since the review due date.

**Why:** Prioritize overdue cases and document possible SLA concerns.

**When:** When checking the review queue and deadlines.

**How I used SQL:** I used `DATEDIFF` on the review due date and our fixed reference date. The case is 34 days past due.

**Expected result:**

| review_id | due_date | status | days_past_due |
| --- | --- | --- | --- |
| REV-00036 | 2026-10-15 | PENDING_CUSTOMER | 34 |


## Query 5 — List the KYC documents

**What:** List the documents already stored for the customer.

**Why:** Avoid claiming that evidence is missing before checking the file.

**When:** During the document inventory.

**How I used SQL:** I selected both document rows. Each is marked VERIFIED in the synthetic records.

**Expected result:**

| document_id | document_type | holder_name | issue_date | expiry_date | verification_status | discrepancy_code |
| --- | --- | --- | --- | --- | --- | --- |
| DOC-000072 | ADDRESS_PROOF | Olson, Evans and Thomas | 2026-08-15 | — | VERIFIED | — |
| DOC-000071 | PASSPORT | Olson, Evans and Thomas | 2023-02-06 | 2028-01-10 | VERIFIED | — |


## Query 6 — Check document expiry separately from verification

**What:** Check expiry dates without confusing them with verification status.

**Why:** A review can be overdue even when a passport is still valid.

**When:** When assessing document freshness and validity.

**How I used SQL:** I used `CASE` to separate expired records from records without a stored expiry date. The passport has not expired.

**Expected result:**

| document_type | expiry_date | verification_status | expiry_check |
| --- | --- | --- | --- |
| ADDRESS_PROOF | — | VERIFIED | NO_EXPIRY_RECORDED |
| PASSPORT | 2028-01-10 | VERIFIED | NOT_EXPIRED |


## Query 7 — Compare names on the documents

**What:** Compare recorded names on the two documents with the customer name.

**Why:** Spot a basic mismatch that could require clarification.

**When:** When reviewing identity and address evidence.

**How I used SQL:** I joined documents to the customer name and used `CASE` to compare them. Both strings match, but this is only a basic comparison.

**Expected result:**

| document_type | customer_name | document_name | name_check |
| --- | --- | --- | --- |
| ADDRESS_PROOF | Olson, Evans and Thomas | Olson, Evans and Thomas | NAME_MATCH |
| PASSPORT | Olson, Evans and Thomas | Olson, Evans and Thomas | NAME_MATCH |


## Query 8 — Compare the recorded and proof addresses

**What:** Compare the address in the customer profile with the address proof.

**Why:** Check whether the available records show an inconsistency.

**When:** During address review in the periodic refresh.

**How I used SQL:** I joined the address proof to the customer profile and compared the two address fields. They match in this training data.

**Expected result:**

| registered_address | address_on_document | verification_status | address_check |
| --- | --- | --- | --- |
| 46 Training Avenue, Indore (fictional) | 46 Training Avenue, Indore (fictional) | VERIFIED | MATCH |


## Query 9 — Check the document-refresh request against the passport record

**What:** View the refresh request next to the passport already on file.

**Why:** Understand why a new record was requested despite a verified, unexpired passport.

**When:** Before sending a duplicate request or escalating an overdue request.

**How I used SQL:** I placed the information request alongside the existing passport record. This exposed the question I need to resolve: why refresh a passport that appears valid?

**Expected result:**

| request_type | request_reason | request_status | document_type | expiry_date | verification_status |
| --- | --- | --- | --- | --- | --- |
| DOCUMENT_REFRESH | Refresh identity record | OVERDUE | PASSPORT | 2028-01-10 | VERIFIED |


## Query 10 — Review the outstanding information request

**What:** Check what was requested and whether the customer replied.

**Why:** Identify the actual information gap and overdue follow-up.

**When:** When a case shows pending-customer status.

**How I used SQL:** I read the request dates, status and response field. There is no recorded response and the request is marked OVERDUE.

**Expected result:**

| request_id | request_type | request_reason | requested_date | due_date | request_status | response_date |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-00036-01 | DOCUMENT_REFRESH | Refresh identity record | 2026-10-21 | 2026-11-01 | OVERDUE | — |


## Query 11 — Calculate the request delay

**What:** Measure how long the outstanding request has been overdue.

**Why:** Support a timely follow-up and explain the delay.

**When:** During pending-information tracking.

**How I used SQL:** I used `DATEDIFF` on the request due date. The request is 17 days past due on our reference date.

**Expected result:**

| request_id | due_date | request_status | days_past_due |
| --- | --- | --- | --- |
| REQ-00036-01 | 2026-11-01 | OVERDUE | 17 |


## Query 12 — Compare the request date with the review deadline

**What:** Check whether the information request was raised before or after the review deadline.

**Why:** Help identify an avoidable process delay or an issue that needs explaining.

**When:** When reviewing overdue case handling or QA findings.

**How I used SQL:** I joined the review and request using `review_id`. The request was made 6 days after the review deadline.

**Expected result:**

| review_id | review_due_date | requested_date | days_requested_after_due |
| --- | --- | --- | --- |
| REV-00036 | 2026-10-15 | 2026-10-21 | 6 |


## Query 13 — Read the case event history

**What:** Read the sequence of actions entered in the case.

**Why:** Check whether the case notes support the recorded status.

**When:** Before writing an investigation summary or handing over the case.

**How I used SQL:** I ordered the case events by date. Only case opening and an information request are documented.

**Expected result:**

| event_date | event_type | notes | actor |
| --- | --- | --- | --- |
| 2026-09-15 | CASE_OPENED | Case assigned to analyst | ANL-017 |
| 2026-10-21 | INFORMATION_REQUESTED | Supporting evidence requested | ANL-017 |


## Query 14 — Check the recorded source of funds and expected activity

**What:** Read the customer’s declared financial background and expected activity.

**Why:** Understand what the existing file says before requesting updated information.

**When:** During customer-profile refresh and when considering EDD.

**How I used SQL:** I selected the financial declarations as background. The income and expected activity use SCU, not real currency.

**Expected result:**

| profile_effective_date | annual_income_scu | source_of_funds | source_of_wealth | expected_monthly_value_scu | expected_monthly_txn_count | expected_counterparty_countries | funding_information_status | declared_unit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2025-06-01 | 600000 | Salary | Employment income and savings | 65000 | 10 | IN\|SG | SELF_DECLARED | SCU |


## Query 15 — Check whether the customer description needs clarification

**What:** View customer type, sector and occupation together.

**Why:** A corporate-style name and crypto-exchange sector for an individual consultant deserve an explanation, not a silent correction.

**When:** During consistency checks on the customer profile.

**How I used SQL:** I joined the customer category and sector with the stated occupation. I would clarify these details instead of changing the source record.

**Expected result:**

| client_name | client_type | sector | sector_risk | occupation |
| --- | --- | --- | --- | --- |
| Olson, Evans and Thomas | Individual | Crypto Exchange | High | Consultant |


## Query 16 — Check for screening alerts recorded in the pack

**What:** Check whether this case has a screening alert record.

**Why:** Avoid assuming that a zero customer flag proves screening clearance.

**When:** When reviewing the available screening evidence in a periodic refresh.

**How I used SQL:** I checked the simulated screening table for this customer. It returned no rows, which is not the same as proof of screening clearance.

**Expected result:**

*No rows returned.*


## Query 17 — Read the draft risk assessment

**What:** Read the provisional customer risk assessment.

**Why:** Check its status and supporting factors before relying on it.

**When:** After reviewing customer profile and missing information.

**How I used SQL:** I read the existing risk score and status. It proposes MEDIUM, but the assessment is still a draft.

**Expected result:**

| assessment_id | sector_risk | pep_indicator | sanctions_indicator | simulated_risk_score | proposed_risk_band | assessment_status | scoring_method |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RISK-00036 | High | 0 | 0 | 3 | MEDIUM | DRAFT_PENDING_REVIEW | TRAINING_RULES_NOT_BANK_POLICY |


## Query 18 — Compare sector risk with the draft customer rating

**What:** Flag the difference between High sector risk and the proposed Medium customer rating.

**Why:** Ensure the draft decision has a defensible explanation. It is not automatically an error.

**When:** Before submitting the risk recommendation for approval.

**How I used SQL:** I used a simple `CASE` flag to highlight the High sector risk against the draft MEDIUM overall band. It means review the reasoning, not automatically call the score wrong.

**Expected result:**

| sector_risk | proposed_risk_band | assessment_status | rating_check |
| --- | --- | --- | --- |
| High | MEDIUM | DRAFT_PENDING_REVIEW | REVIEW_RATING |


## Query 19 — Check whether an EDD record exists

**What:** Check whether an enhanced due diligence review is recorded.

**Why:** An absent EDD row is not evidence that EDD was completed or not needed.

**When:** When the risk factors suggest enhanced checks may be appropriate.

**How I used SQL:** I looked for an EDD review record and found none. I cannot describe the EDD decision as completed or waived.

**Expected result:**

*No rows returned.*


## Query 20 — Review the QA finding

**What:** See what the quality reviewer flagged.

**Why:** Make sure any pending correction is addressed before recommending closure.

**When:** During case rework or quality review.

**How I used SQL:** I read the recorded QA finding. It specifically points to the overdue information request and says correction is required.

**Expected result:**

| qa_id | qa_date | qa_status | finding | correction_required |
| --- | --- | --- | --- | --- |
| QA-00036 | 2026-11-17 | OPEN_FINDING | OVERDUE_INFORMATION_REQUEST | YES |


## Query 21 — Count information requests not yet closed

**What:** Count requests still needing action.

**Why:** Provide a clear follow-up workload for the case.

**When:** Before writing the next-action recommendation.

**How I used SQL:** I counted requests with `OPEN` or `OVERDUE` status. There is one outstanding request.

**Expected result:**

| outstanding_requests |
| --- |
| 1 |


## Query 22 — Check the review, risk and QA statuses together

**What:** See the open review, draft risk assessment and QA finding in one view.

**Why:** Avoid marking the review complete while important follow-ups remain.

**When:** At the end of the L1 case assessment.

**How I used SQL:** I used two `LEFT JOIN`s by `review_id` to see the case, risk and QA statuses together. None supports closing the review yet.

**Expected result:**

| review_id | review_status | assessment_status | qa_status |
| --- | --- | --- | --- |
| REV-00036 | PENDING_CUSTOMER | DRAFT_PENDING_REVIEW | OPEN_FINDING |


## Query 23 — Count documents not marked verified

**What:** Check whether any simulated document record has a non-verified status.

**Why:** Distinguish document status from overall review completion.

**When:** During a final document-status check.

**How I used SQL:** I counted records not labelled VERIFIED. The result is zero, but that does not resolve the overdue request or prove documents were independently authenticated.

**Expected result:**

| documents_not_verified |
| --- |
| 0 |


## Query 24 — Check documents are linked to a customer

**What:** Check for document rows without a matching customer.

**Why:** Prevent using evidence attached to a missing customer record.

**When:** During technical data validation for the portfolio project.

**How I used SQL:** I used a `LEFT JOIN` to catch document rows with no matching master customer. The count is zero.

**Expected result:**

| unmatched_documents |
| --- |
| 0 |


## Query 25 — Check the information request belongs to the correct review

**What:** Confirm the information request points to a review for the same customer.

**Why:** Avoid drawing findings from a request linked to the wrong review.

**When:** During the initial data-quality check.

**How I used SQL:** I compared the request’s client ID with the client ID on its review. No mismatch was found.

**Expected result:**

| mismatched_requests |
| --- |
| 0 |


## Query 26 — Check the QA finding belongs to the correct review

**What:** Confirm the QA finding belongs to the right customer and review.

**Why:** Prevent wrongly attributing a quality issue to this case.

**When:** During technical data validation.

**How I used SQL:** I made the same simple check for the QA review. The QA record points to the correct customer and review.

**Expected result:**

| mismatched_qa_records |
| --- |
| 0 |

