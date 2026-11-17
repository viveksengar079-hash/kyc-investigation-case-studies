# Case Study 6 — SQL Query Explanations

This file explains every query in the order I ran it. I have kept the SQL simple and focused on the KYC/EDD questions that matter.

**Fixed reference date:** 18 November 2026. The date is hard-coded only so the overdue calculation stays consistent when I practise later.

**Data limitation:** The financial profile uses simulated SCU values; the original transactions have no currency. I do not compare their amounts directly.

## Case intake and identification

### Query 1 — Review the assigned KYC case

**What:** Check the review type, assignment, trigger and due date.

**Why:** I need to know why the customer is in the queue and when the review is due.

**When:** When I pick up the case.

**What I found:** REV-01877 is an OPEN, HIGH-priority PERIODIC review, due 13 Nov 2026. It was not generated as an event-driven PEP review.

**SQL**
```sql
SELECT
    r.review_id,
    r.client_id,
    c.client_name,
    r.review_type,
    r.`trigger`,
    r.opened_date,
    r.due_date,
    r.status,
    r.review_priority
FROM kyc_reviews r
JOIN clients_master c ON r.client_id = c.client_id
WHERE r.client_id = 1877;
```

### Query 2 — Read the customer risk indicators

**What:** Check the original customer type, country, sector and screening flags.

**Why:** High-risk CDD starts with understanding why the customer needs more attention.

**When:** At the beginning of the risk review.

**What I found:** An Individual in VE, with Crypto Exchange sector risk HIGH, PEP flag 1, sanctions flag 0 and OFAC country flag 1. Flags do not prove a match.

**SQL**
```sql
SELECT
    client_id,
    client_name,
    client_type,
    country,
    sector,
    sector_risk,
    pep_flag,
    sanctions_flag,
    ofac_country_flag,
    record_origin
FROM clients_master
WHERE client_id = 1877;
```

### Query 3 — Check the personal profile

**What:** Read the occupation, customer address and relationship status.

**Why:** I need basic customer context before deciding what financial evidence to request.

**When:** During CDD profile review.

**What I found:** The fictional profile says Small business owner with an ACTIVE relationship. Occupation and sector need a business-activity explanation.

**SQL**
```sql
SELECT
    client_id,
    date_of_birth,
    occupation,
    registered_address,
    relationship_start_date,
    relationship_status,
    record_origin
FROM customer_profiles
WHERE client_id = 1877;
```

### Query 4 — Check the account on file

**What:** Confirm the training record has an account linked to this client.

**Why:** An existing account helps distinguish a periodic review from initial onboarding.

**When:** During initial case intake.

**What I found:** The case belongs to an existing customer with a simulated account.

**SQL**
```sql
SELECT
    account_id,
    account_type,
    open_date,
    account_status
FROM accounts
WHERE client_id = 1877;
```

### Query 5 — Review the identity documents

**What:** List passport and address-proof details and their recorded verification statuses.

**Why:** Before asking for extra documents, I should know what has already been checked.

**When:** During document sufficiency review.

**What I found:** Two simulated records: passport and address proof, both VERIFIED; passport expires in 2029. These do not verify the source of wealth.

**SQL**
```sql
SELECT
    document_id,
    document_type,
    holder_name,
    expiry_date,
    verification_status,
    discrepancy_code
FROM kyc_documents
WHERE client_id = 1877
ORDER BY document_type;
```

### Query 6 — Check names on the identity records

**What:** Compare document holder names with the customer name.

**Why:** This prevents me from overlooking a simple identity discrepancy.

**When:** When reviewing the supporting documents.

**What I found:** Both simulated document holder names match the customer name.

**SQL**
```sql
SELECT
    d.document_type,
    c.client_name AS customer_name,
    d.holder_name AS document_name,
    CASE
        WHEN c.client_name = d.holder_name THEN 'NAME_MATCH'
        ELSE 'CHECK_NAME'
    END AS name_check
FROM kyc_documents d
JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1877
ORDER BY d.document_type;
```

## Screening and background checks

### Query 7 — Review the outstanding PEP alert

**What:** Read the watchlist candidate, screening source and current status.

**Why:** A PEP flag may require further checks, but the alert needs evidence before confirmation.

**When:** When screening concerns affect the risk assessment.

**What I found:** One OPEN simulated PEP alert. The candidate position is only “Simulated risk record,” not an independently verified political office.

**SQL**
```sql
SELECT
    alert_id,
    review_id,
    screening_type,
    candidate_name,
    candidate_dob,
    candidate_country,
    candidate_position,
    screening_source,
    identifier_comparison,
    recommendation,
    alert_status
FROM screening_alerts
WHERE client_id = 1877;
```

### Query 8 — Compare the PEP candidate details

**What:** Check whether date of birth and country match the client profile.

**Why:** Identifier comparison helps prioritize verification but cannot prove political exposure.

**When:** After opening the screening alert.

**What I found:** DOB and country match. The underlying political role is still unverified.

**SQL**
```sql
SELECT
    s.alert_id,
    s.candidate_name,
    CASE
        WHEN s.candidate_dob = p.date_of_birth THEN 'DOB_MATCH'
        ELSE 'DOB_DIFFERENT'
    END AS dob_check,
    CASE
        WHEN s.candidate_country = p.country THEN 'COUNTRY_MATCH'
        ELSE 'COUNTRY_DIFFERENT'
    END AS country_check
FROM screening_alerts s
JOIN customer_profiles p ON s.client_id = p.client_id
WHERE s.client_id = 1877;
```

### Query 9 — Check available adverse-media leads

**What:** See whether the training database holds an adverse-media result.

**Why:** I should not invent an allegation when no record is supplied.

**When:** During higher-risk background checks.

**What I found:** No adverse-media row exists in this synthetic pack for the client. That is not a real-world clearance.

**SQL**
```sql
SELECT
    media_id,
    headline,
    alleged_issue,
    publication_date,
    disposition
FROM adverse_media_hits
WHERE client_id = 1877;
```

## Financial declarations, risk and EDD

### Query 10 — Review the financial declarations

**What:** Read the stated source of funds, source of wealth, income and expected activity.

**Why:** These are central details for assessing the customer’s financial background.

**When:** When starting EDD financial review.

**What I found:** Annual income 90,000 SCU; source of funds Professional fees; source of wealth Inheritance and investments; both SELF_DECLARED.

**SQL**
```sql
SELECT
    client_id,
    profile_effective_date,
    annual_income_scu,
    source_of_funds,
    source_of_wealth,
    expected_monthly_value_scu,
    expected_monthly_txn_count,
    expected_counterparty_countries,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 1877;
```

### Query 11 — Check what financial evidence has been verified

**What:** Display the declared funds and wealth next to the information status.

**Why:** A customer statement is a starting point, not independent proof.

**When:** Before making an EDD recommendation.

**What I found:** Both declarations need supporting evidence; funding status is SELF_DECLARED.

**SQL**
```sql
SELECT
    source_of_funds,
    source_of_wealth,
    funding_information_status,
    CASE
        WHEN funding_information_status = 'VERIFIED' THEN 'RECORDED_AS_VERIFIED'
        ELSE 'SUPPORT_NEEDED'
    END AS evidence_check
FROM customer_financial_profiles
WHERE client_id = 1877;
```

### Query 12 — Review the draft customer risk assessment

**What:** Read the draft score and customer risk band.

**Why:** The analyst should understand a proposed rating without presenting it as final.

**When:** After reviewing the customer risk factors.

**What I found:** Proposed HIGH, simulated score 5, DRAFT_PENDING_REVIEW. This is a training method, not a bank risk model.

**SQL**
```sql
SELECT
    assessment_id,
    review_id,
    sector_risk,
    pep_indicator,
    sanctions_indicator,
    simulated_risk_score,
    proposed_risk_band,
    assessment_status,
    scoring_method
FROM risk_assessments
WHERE client_id = 1877;
```

### Query 13 — Review the EDD record

**What:** See what enhanced checks are complete and whether approval exists.

**Why:** I cannot treat a case as cleared if EDD has not even started.

**When:** When higher risk calls for enhanced review.

**What I found:** EDD is NOT_STARTED; SoF and SoW have DECLARATION_RECORDED and approval is NOT_REQUESTED.

**SQL**
```sql
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 1877;
```

## Workflow, deadlines and QA

### Query 14 — Check existing information requests

**What:** List any information already requested from the customer.

**Why:** I should avoid duplicating requests or claiming a follow-up exists when none is logged.

**When:** Before preparing a new request.

**What I found:** Zero rows: no existing request is recorded in this training pack. We can propose one; the SQL does not create it.

**SQL**
```sql
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 1877;
```

### Query 15 — Check the periodic review deadline

**What:** Calculate how many days have passed since the recorded due date.

**Why:** High-priority overdue reviews may require timely operational follow-up.

**When:** While checking workload and case urgency.

**What I found:** Due 13 Nov 2026: five days after due as of the fixed training date 18 Nov 2026; review OPEN.

**SQL**
```sql
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF('2026-11-18', due_date) AS days_after_due_date
FROM kyc_reviews
WHERE client_id = 1877;
```

### Query 16 — Review recorded case actions

**What:** Read the timeline of actions on this KYC review.

**Why:** Documented case events show what has and has not been done.

**When:** When checking prior work before escalation.

**What I found:** Only the simulated CASE_OPENED event is recorded; that does not document any completed EDD review.

**SQL**
```sql
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 1877
ORDER BY event_date;
```

### Query 17 — Look for recorded QA findings

**What:** Check whether any QA review exists for the customer.

**Why:** A missing QA record must not be reported as a QA pass.

**When:** When assessing whether the case can move toward closure.

**What I found:** No QA record in the supplied data. No QA approval can be claimed.

**SQL**
```sql
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 1877;
```

## Limited supporting activity context

### Query 18 — Summarize transaction history for customer context

**What:** Count recorded payments and see the date range.

**Why:** A KYC/EDD analyst may review activity context but should not pretend to have completed a TM investigation.

**When:** If actual activity is relevant to the risk review.

**What I found:** 28 historical payments, total 159379.03 with no stated currency, from July–September 2025.

**SQL**
```sql
SELECT
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS recorded_total,
    MIN(timestamp) AS first_transaction,
    MAX(timestamp) AS last_transaction
FROM transactions
WHERE client_id = 1877;
```

### Query 19 — Compare monthly transaction frequency

**What:** Count transactions in each month.

**Why:** Monthly counts can be compared with expected frequency, unlike amounts without matching units.

**When:** During a limited KYC activity-consistency check.

**What I found:** Counts: July 8, August 11, September 9, compared with five expected per month in the simulated financial profile.

**SQL**
```sql
SELECT
    SUBSTRING(timestamp, 1, 7) AS transaction_month,
    COUNT(*) AS transaction_count
FROM transactions
WHERE client_id = 1877
GROUP BY SUBSTRING(timestamp, 1, 7)
ORDER BY transaction_month;
```

### Query 20 — Check where counterparties are recorded

**What:** Summarize source counterparty countries.

**Why:** I need to understand whether the profile’s expected countries reflect observed relationships.

**When:** During financial-activity context review.

**What I found:** Counterparties include NL, FR, AU, CA, DE and other countries; profile lists VE|IN as expected countries.

**SQL**
```sql
SELECT
    counterparty_country,
    COUNT(*) AS transaction_count
FROM transactions
WHERE client_id = 1877
GROUP BY counterparty_country
ORDER BY transaction_count DESC, counterparty_country;
```

### Query 21 — Count counterparties outside the stated expected countries

**What:** Count transaction records involving countries beyond the training profile’s VE and IN list.

**Why:** This shows what needs clarification, not a concluded offence.

**When:** When identifying questions about customer expected activity.

**What I found:** One transaction with IN; 27 involve other countries. The allowed-country list comes from a simulated declaration.

**SQL**
```sql
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN counterparty_country IN ('VE', 'IN') THEN 1 ELSE 0 END) AS expected_country_transactions,
    SUM(CASE WHEN counterparty_country NOT IN ('VE', 'IN') THEN 1 ELSE 0 END) AS other_country_transactions
FROM transactions
WHERE client_id = 1877;
```

### Query 22 — Read recorded transaction risk flags

**What:** Count automated risk indicators within the available history.

**Why:** A flag can justify a specialist referral, but does not establish rapid movement or illicit funds.

**When:** When checking whether the EDD file references other risk indicators.

**What I found:** Four rapid-movement flags, no structuring or OFAC-match flags. Their underlying monitoring logic is not provided.

**SQL**
```sql
SELECT
    COUNT(*) AS transaction_count,
    SUM(rapid_movement_flag) AS rapid_movement_flags,
    SUM(structuring_pattern_flag) AS structuring_flags,
    SUM(ofac_match_flag) AS ofac_flags
FROM transactions
WHERE client_id = 1877;
```

### Query 23 — Review the three largest recorded payments

**What:** List the biggest source transactions for possible clarification.

**Why:** Large payments may prompt questions about financial background, but amount alone proves nothing.

**When:** If the EDD reviewer needs examples to request transaction purpose evidence.

**What I found:** Largest recorded values include transaction 34291 (61695.22) and 37789 (39544.58); the currency is not provided.

**SQL**
```sql
SELECT
    transaction_id,
    timestamp,
    amount,
    transaction_type,
    counterparty_country
FROM transactions
WHERE client_id = 1877
ORDER BY amount DESC
LIMIT 3;
```

## Final status and integrity checks

### Query 24 — Check the review, risk and EDD statuses together

**What:** Bring the three workflow statuses into one result.

**Why:** A case must not be called complete when risk assessment and EDD remain unfinished.

**When:** Before documenting the analyst recommendation.

**What I found:** Review OPEN, risk DRAFT_PENDING_REVIEW, EDD NOT_STARTED.

**SQL**
```sql
SELECT
    r.review_id,
    r.status AS review_status,
    a.assessment_status,
    e.edd_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN edd_reviews e ON r.review_id = e.review_id
WHERE r.client_id = 1877;
```

### Query 25 — Check that documents link to the correct customer

**What:** Count document records linked to an unknown customer.

**Why:** A wrong customer link could undermine the whole file review.

**When:** During basic integrity checks.

**What I found:** Zero unmatched documents.

**SQL**
```sql
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1877
  AND c.client_id IS NULL;
```

### Query 26 — Check that the PEP alert links to this review

**What:** Find screening alerts with a missing or wrongly linked review.

**Why:** An alert must belong to the same person and review I am investigating.

**When:** During basic integrity checks.

**What I found:** Zero mismatched screening alerts.

**SQL**
```sql
SELECT
    COUNT(*) AS mismatched_alerts
FROM screening_alerts s
LEFT JOIN kyc_reviews r ON s.review_id = r.review_id
WHERE s.client_id = 1877
  AND (r.review_id IS NULL OR s.client_id <> r.client_id);
```

### Query 27 — Check that the EDD record links to this review

**What:** Find EDD rows linked to a different client or missing review.

**Why:** I should not rely on an EDD status that belongs to another case.

**When:** During basic integrity checks.

**What I found:** Zero mismatched EDD records.

**SQL**
```sql
SELECT
    COUNT(*) AS mismatched_edd_records
FROM edd_reviews e
LEFT JOIN kyc_reviews r ON e.review_id = r.review_id
WHERE e.client_id = 1877
  AND (r.review_id IS NULL OR e.client_id <> r.client_id);
```
