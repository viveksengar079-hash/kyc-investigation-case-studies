# SQL Query Explanation — Individual KYC Review

**Case:** REV-01708 / Client 1708  
**SQL file:** [`../sql/investigation.sql`](../sql/investigation.sql)

I kept the SQL simple so I could understand each check and explain why I used it. All 22 queries are read-only. In a bank, an analyst might do many of these checks in a KYC system rather than by writing SQL directly.

The **When** below means when the *business check* is useful in a KYC review, not that an analyst must always run that SQL query.

## Block 1 — Case intake and customer details (Queries 1–3)

### Query 1 — Why was the case assigned?

- **What:** I joined `kyc_reviews` with `clients_master` using `client_id` to see the case and customer together.
- **Why:** I needed to know the review trigger, assigned analyst, priority, and due date before looking at documents.
- **When:** At the start of a new KYC case.
- **What I found:** `REV-01708` is an open event-driven review for `PEP_FLAG_REVIEW`. It is marked HIGH priority and assigned to `ANL-009`.

**SQL point:** `JOIN` connects the two tables through the same customer ID. The backticks around `` `trigger` `` are needed because `TRIGGER` is a MySQL keyword.

### Query 2 — Basic customer profile

- **What:** I selected the customer's name, type, country, sector, and existing risk flags from `clients_master`.
- **Why:** I wanted to understand which risk indicators were already recorded before making any judgment.
- **When:** During initial customer profiling.
- **What I found:** Burton-Acosta is an individual in India, associated with real estate. `pep_flag = 1`, `sanctions_flag = 0`, and sector risk is Medium.

**SQL point:** `WHERE client_id = 1708` limits the result to the customer being reviewed.

### Query 3 — Personal details and relationship

- **What:** I checked the date of birth, occupation, address, relationship start date, and status in `customer_profiles`.
- **Why:** These details are needed for identification checks and to understand the customer relationship.
- **When:** During CDD or when existing details need to be refreshed.
- **What I found:** The simulated profile gives a DOB of 14 June 1991, occupation as real estate consultant, an Indore address, and an active relationship.

**Note:** These personal details are simulated; they did not exist in the original Kaggle customer CSV.

## Block 2 — Documents and address checks (Queries 4–6)

### Query 4 — Available KYC documents

- **What:** I listed the customer's document records and their verification statuses.
- **Why:** Having a document on file is different from having a verified document.
- **When:** During identity and address checks.
- **What I found:** Two simulated records: a passport marked `PENDING` and an address proof marked `REQUIRES_CLARIFICATION`.

**SQL point:** `ORDER BY document_type` keeps the results easy to read.

### Query 5 — Name comparison

- **What:** I compared `holder_name` on each document with `client_name` in the master table.
- **Why:** I wanted to spot an obvious name difference that might require checking.
- **When:** During document review.
- **What I found:** Both document names returned `NAME_MATCH`.

**SQL point:** I used a simple `CASE WHEN` to label the result. An exact text match does not prove a document is genuine, and differences in spelling or formatting may need manual review.

### Query 6 — Address comparison

- **What:** I joined the profile and address-proof record, then compared the two address fields.
- **Why:** Different addresses need clarification before I can rely on the recorded address.
- **When:** During address verification or an address-related KYC refresh.
- **What I found:** The result was `MISMATCH`, with the recorded discrepancy code `ADDRESS_MISMATCH`.

**SQL point:** The `CASE` statement checks text equality only. It does not decide whether either address is genuine or current.

## Block 3 — Screening (Queries 7–10)

### Query 7 — Simulated PEP candidates

- **What:** I read the candidate details from `screening_alerts`.
- **Why:** A PEP flag by itself does not explain who matched or why.
- **When:** When a screening alert needs investigation.
- **What I found:** Two open fictional PEP alerts: `SCR-00140` and `SCR-00141`.

**SQL point:** These records are from a training watchlist, not Dilisense or an actual bank screening system.

### Query 8 — Compare candidate identifiers

- **What:** I compared each candidate's DOB and country against the simulated customer profile using `CASE` statements.
- **Why:** Matching identifiers make an alert more relevant, while clear differences may support a false-positive decision.
- **When:** During screening-match review.
- **What I found:** `SCR-00140` matched on DOB and country; `SCR-00141` differed on both.

**SQL point:** This is a first-pass comparison. The query does not verify identity or close either alert.

### Query 9 — Dilisense search record

- **What:** I read the separate name-search entry in `screening_search_log`.
- **Why:** I wanted to keep the reported external search separate from our simulated internal alerts.
- **When:** When checking what screening evidence is available.
- **What I found:** A user-reported Dilisense search returned `NO_MATCH_FOUND`; evidence status is `USER_REPORTED_NOT_INDEPENDENTLY_VERIFIED`.

**Important:** This result cannot confirm or dismiss the fictional alerts.

### Query 10 — Adverse-media records

- **What:** I checked `adverse_media_hits` for any records linked to this customer.
- **Why:** Relevant adverse media may require further review when evaluating customer risk.
- **When:** As part of a risk-based screening or due diligence review.
- **What I found:** No rows for Client 1708 in this synthetic table.

**Important:** No row in this table does not mean a full adverse-media search was negative.

## Block 4 — Financial profile and activity context (Queries 11–13)

### Query 11 — Declared financial information

- **What:** I reviewed income, source of funds, source of wealth, and expected activity in `customer_financial_profiles`.
- **Why:** These details help explain what activity the customer says is normal.
- **When:** During customer risk assessment or EDD where relevant.
- **What I found:** Source of funds is recorded as business fees, expected monthly value is 15,000 SCU, and funding information is `UNVERIFIED`.

**Important:** SCU means simulated currency units, not INR or USD.

### Query 12 — Basic transaction summary

- **What:** I counted transactions, added recorded amounts, and found the earliest and latest transaction dates.
- **Why:** A KYC reviewer may need a basic view of the customer's activity to understand their profile.
- **When:** During a relevant periodic or event-driven review, especially if expected activity needs clarification.
- **What I found:** 28 transactions totalling 209,711.58 in unspecified amount units, from July to September 2025.

**SQL point:** `COUNT`, `SUM`, `MIN`, and `MAX` give a summary without examining individual TM alerts. The original amounts cannot be directly compared with SCU values.

### Query 13 — Foreign counterparty count

- **What:** I counted records where the counterparty country was different from the customer country.
- **Why:** The customer profile lists expected counterparty countries, so I wanted a simple measure of international activity.
- **When:** When geographic activity is relevant to the KYC review.
- **What I found:** 25 transactions involved foreign counterparties.

**SQL point:** `<>` means “not equal to.” A foreign counterparty is not automatically suspicious, and the data does not identify transaction direction.

## Block 5 — Risk assessment and EDD (Queries 14–15)

### Query 14 — Draft risk assessment

- **What:** I checked the existing simulated risk score and assessment status.
- **Why:** I needed to know whether the case already had a proposed rating and whether it was final.
- **When:** During customer risk review.
- **What I found:** Score 4, proposed MEDIUM, with status `DRAFT_PENDING_REVIEW`.

**Important:** The method is labelled `TRAINING_RULES_NOT_BANK_POLICY`. The score is not an approved bank risk rating.

### Query 15 — EDD progress

- **What:** I checked the EDD reason, source-of-funds and source-of-wealth verification, approval, and overall EDD status.
- **Why:** I needed to see whether extra checks were outstanding before a decision.
- **When:** When EDD has been opened or is required under the institution's policy.
- **What I found:** EDD is `IN_PROGRESS`; source-of-funds verification is `REQUIRED`, source-of-wealth verification is `PENDING`, and management approval is `NOT_REQUESTED`.

**SQL point:** This retrieves the recorded EDD status; it does not itself decide whether EDD requirements have been satisfied.

## Block 6 — Information requests (Queries 16–17)

### Query 16 — Outstanding information requests

- **What:** I listed the customer's requests and their due dates.
- **Why:** I wanted to see exactly what evidence was still needed rather than writing a vague “more information required” note.
- **When:** Before following up with the customer or handing over the case.
- **What I found:** Three open requests: current address, original PEP alert, and source of funds. Each is due 28 November 2026.

**SQL point:** The request types tell me what to follow up on; they don't mean the evidence has already been received.

### Query 17 — Count open requests

- **What:** I counted requests where `request_status = 'OPEN'`.
- **Why:** The count is a quick way to check whether important follow-ups are still pending.
- **When:** During case tracking and before a closure recommendation.
- **What I found:** Three requests are open.

**SQL point:** `COUNT(*)` gives the number of rows meeting the condition.

## Block 7 — Case history, QA, and current status (Queries 18–20)

### Query 18 — Case activity history

- **What:** I read the events recorded in `case_events` in date order.
- **Why:** A reviewer should be able to see what has happened to the case so far.
- **When:** During investigation, handover, or audit preparation.
- **What I found:** The simulated log contains `CASE_OPENED` and `INFORMATION_REQUESTED`.

**SQL point:** `ORDER BY event_date` shows the case events chronologically.

### Query 19 — Quality assurance review

- **What:** I checked whether QA had cleared the case or requested corrections.
- **Why:** A case should not be described as QA-approved unless the record supports that.
- **When:** Before final handoff or closure, depending on workflow.
- **What I found:** QA status is `PENDING`. No substantive QA finding is recorded in this row.

### Query 20 — Current overall status

- **What:** I joined the review, risk assessment, and EDD tables to see their statuses together.
- **Why:** I wanted one final status check before writing the investigation notes.
- **When:** At the end of an investigation review or before handover.
- **What I found:** KYC review `OPEN`, risk assessment `DRAFT_PENDING_REVIEW`, and EDD `IN_PROGRESS`.

**SQL point:** `LEFT JOIN` keeps the review visible even if a linked assessment or EDD record is missing.

## Block 8 — Basic data quality checks (Queries 21–22)

### Query 21 — Documents linked to a known customer

- **What:** I checked whether any document for Client 1708 lacked a matching record in `clients_master`.
- **Why:** I didn't want to use a document linked to an unknown customer.
- **When:** During project data validation; in a bank, similar controls may be built into the system.
- **What I found:** `0` unmatched documents.

**SQL point:** A `LEFT JOIN` with `IS NULL` helps find missing matches. It doesn't authenticate the documents.

### Query 22 — Screening alerts linked to the correct review

- **What:** I checked whether any alert for Client 1708 was missing its review or linked to a review belonging to another customer.
- **Why:** A screening alert must be investigated against the right customer and case.
- **When:** During data validation or when case evidence appears inconsistent.
- **What I found:** `0` mismatched screening alerts.

**SQL point:** The query checks both a missing review and a client-ID mismatch. It doesn't prove the PEP alerts are true matches.

---

## How I would explain the full SQL workflow in an interview

I started with the assigned case and customer details. Then I reviewed the available documents and compared the names and addresses. After that, I checked the simulated screening candidates and their identifiers, followed by the customer's declared financial background and a simple activity summary. Finally, I reviewed the draft risk assessment, EDD status, outstanding information requests, case history, QA, and two basic data checks.

The main point is that I **did not treat a flag as a confirmed finding**. My SQL helped me find and organise the evidence, but the review still needs further verification before a final decision.
