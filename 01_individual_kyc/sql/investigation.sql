-- Case Study 01: Individual KYC review
-- Customer: 1708 | Review: REV-01708
-- Training data only. This file reads data; it does not update anything.

USE kyc_case_studies;

-- 1. See why the case was assigned
SELECT
    r.review_id,
    r.client_id,
    c.client_name,
    r.review_type,
    r.`trigger`,
    r.opened_date,
    r.due_date,
    r.status,
    r.assigned_analyst,
    r.review_priority
FROM kyc_reviews r
JOIN clients_master c ON r.client_id = c.client_id
WHERE r.client_id = 1708;

-- 2. Check the basic customer information
SELECT
    client_id,
    client_name,
    client_type,
    country,
    sector,
    sector_risk,
    pep_flag,
    sanctions_flag,
    record_origin
FROM clients_master
WHERE client_id = 1708;

-- 3. Review the customer's recorded personal details
SELECT
    client_id,
    date_of_birth,
    occupation,
    registered_address,
    relationship_start_date,
    relationship_status,
    record_origin
FROM customer_profiles
WHERE client_id = 1708;

-- 4. Check the documents available in the case
SELECT
    document_id,
    document_type,
    document_reference,
    holder_name,
    issue_date,
    expiry_date,
    address_on_document,
    verification_status,
    discrepancy_code
FROM kyc_documents
WHERE client_id = 1708
ORDER BY document_type;

-- 5. Check whether the name on each document matches
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
WHERE d.client_id = 1708;

-- 6. Compare the declared address with the address proof
SELECT
    p.registered_address AS recorded_address,
    d.address_on_document AS proof_address,
    d.verification_status,
    d.discrepancy_code,
    CASE
        WHEN p.registered_address = d.address_on_document THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS address_check
FROM customer_profiles p
JOIN kyc_documents d ON p.client_id = d.client_id
WHERE p.client_id = 1708
  AND d.document_type = 'ADDRESS_PROOF';

-- 7. Review the simulated PEP screening candidates
SELECT
    alert_id,
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
WHERE client_id = 1708
ORDER BY alert_id;

-- 8. Compare the screening candidates' identifiers
SELECT
    a.alert_id,
    a.candidate_name,
    CASE
        WHEN a.candidate_dob = p.date_of_birth THEN 'DOB_MATCH'
        ELSE 'DOB_DIFFERENT'
    END AS dob_check,
    CASE
        WHEN a.candidate_country = p.country THEN 'COUNTRY_MATCH'
        ELSE 'COUNTRY_DIFFERENT'
    END AS country_check
FROM screening_alerts a
JOIN customer_profiles p ON a.client_id = p.client_id
WHERE a.client_id = 1708
ORDER BY a.alert_id;

-- 9. Read the separately recorded Dilisense name-search result
SELECT
    provider,
    search_name,
    search_date,
    reported_result,
    evidence_status,
    observation
FROM screening_search_log
WHERE client_id = 1708;

-- 10. Check whether any adverse-media leads exist in this pack
SELECT
    media_id,
    headline,
    alleged_issue,
    publication_date,
    disposition
FROM adverse_media_hits
WHERE client_id = 1708;

-- 11. Check the customer's declared financial background
SELECT
    client_id,
    annual_income_scu,
    source_of_funds,
    source_of_wealth,
    expected_monthly_value_scu,
    expected_monthly_txn_count,
    expected_counterparty_countries,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 1708;

-- 12. Check existing transaction activity only for customer context
-- Original amounts have no stated currency; do not compare directly with SCU amounts.
SELECT
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_recorded_amount,
    MIN(timestamp) AS first_transaction,
    MAX(timestamp) AS last_transaction
FROM transactions
WHERE client_id = 1708;

-- 13. Check how many transactions involve a foreign counterparty
SELECT
    COUNT(*) AS foreign_counterparty_transactions
FROM transactions
WHERE client_id = 1708
  AND counterparty_country <> client_country;

-- 14. Review the risk assessment already in the case
-- This is a draft training score, not the bank's final decision.
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
WHERE client_id = 1708;

-- 15. Check whether enhanced due diligence is still needed
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 1708;

-- 16. Review outstanding requests for information
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 1708
ORDER BY request_id;

-- 17. Count the requests that are still open
SELECT
    COUNT(*) AS open_requests
FROM information_requests
WHERE client_id = 1708
  AND request_status = 'OPEN';

-- 18. Review actions recorded on the case
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 1708
ORDER BY event_date;

-- 19. Check whether QA has cleared the case
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 1708;

-- 20. Check the current case and risk statuses before writing notes
SELECT
    r.review_id,
    r.status AS review_status,
    a.assessment_status,
    e.edd_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN edd_reviews e ON r.review_id = e.review_id
WHERE r.client_id = 1708;

-- 21. Data check: make sure the documents belong to a known customer
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1708
  AND c.client_id IS NULL;

-- 22. Data check: make sure the screening alerts belong to this review
SELECT
    COUNT(*) AS mismatched_screening_alerts
FROM screening_alerts a
LEFT JOIN kyc_reviews r ON a.review_id = r.review_id
WHERE a.client_id = 1708
  AND (r.review_id IS NULL OR a.client_id <> r.client_id);

-- Analyst conclusion for the written report:
-- Address evidence needs clarification; the original PEP flag is unresolved.
-- A user-reported no-match search does not close the simulated internal alert.
-- Source-of-funds review and EDD are pending. Do not mark the case approved.
