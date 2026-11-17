-- Case Study 06: High-risk CDD, source of funds and source of wealth
-- Client: 1877 | Review: REV-01877
-- Synthetic training case. Only SELECT queries; nothing is updated.
-- Reference date for deadline checks: 2026-11-18
-- The SCU amounts in generated profiles are NOT comparable with the
-- original transaction amounts because the original currency is unknown.

USE kyc_case_studies;

-- Case intake and identification

-- 1. Review the assigned KYC case
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

-- 2. Read the customer risk indicators
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

-- 3. Check the personal profile
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

-- 4. Check the account on file
SELECT
    account_id,
    account_type,
    open_date,
    account_status
FROM accounts
WHERE client_id = 1877;

-- 5. Review the identity documents
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

-- 6. Check names on the identity records
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

-- Screening and background checks

-- 7. Review the outstanding PEP alert
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

-- 8. Compare the PEP candidate details
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

-- 9. Check available adverse-media leads
SELECT
    media_id,
    headline,
    alleged_issue,
    publication_date,
    disposition
FROM adverse_media_hits
WHERE client_id = 1877;

-- Financial declarations, risk and EDD

-- 10. Review the financial declarations
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

-- 11. Check what financial evidence has been verified
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

-- 12. Review the draft customer risk assessment
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

-- 13. Review the EDD record
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 1877;

-- Workflow, deadlines and QA

-- 14. Check existing information requests
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 1877;

-- 15. Check the periodic review deadline
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF('2026-11-18', due_date) AS days_after_due_date
FROM kyc_reviews
WHERE client_id = 1877;

-- 16. Review recorded case actions
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 1877
ORDER BY event_date;

-- 17. Look for recorded QA findings
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 1877;

-- Limited supporting activity context

-- 18. Summarize transaction history for customer context
SELECT
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS recorded_total,
    MIN(timestamp) AS first_transaction,
    MAX(timestamp) AS last_transaction
FROM transactions
WHERE client_id = 1877;

-- 19. Compare monthly transaction frequency
SELECT
    SUBSTRING(timestamp, 1, 7) AS transaction_month,
    COUNT(*) AS transaction_count
FROM transactions
WHERE client_id = 1877
GROUP BY SUBSTRING(timestamp, 1, 7)
ORDER BY transaction_month;

-- 20. Check where counterparties are recorded
SELECT
    counterparty_country,
    COUNT(*) AS transaction_count
FROM transactions
WHERE client_id = 1877
GROUP BY counterparty_country
ORDER BY transaction_count DESC, counterparty_country;

-- 21. Count counterparties outside the stated expected countries
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN counterparty_country IN ('VE', 'IN') THEN 1 ELSE 0 END) AS expected_country_transactions,
    SUM(CASE WHEN counterparty_country NOT IN ('VE', 'IN') THEN 1 ELSE 0 END) AS other_country_transactions
FROM transactions
WHERE client_id = 1877;

-- 22. Read recorded transaction risk flags
SELECT
    COUNT(*) AS transaction_count,
    SUM(rapid_movement_flag) AS rapid_movement_flags,
    SUM(structuring_pattern_flag) AS structuring_flags,
    SUM(ofac_match_flag) AS ofac_flags
FROM transactions
WHERE client_id = 1877;

-- 23. Review the three largest recorded payments
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

-- Final status and integrity checks

-- 24. Check the review, risk and EDD statuses together
SELECT
    r.review_id,
    r.status AS review_status,
    a.assessment_status,
    e.edd_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN edd_reviews e ON r.review_id = e.review_id
WHERE r.client_id = 1877;

-- 25. Check that documents link to the correct customer
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1877
  AND c.client_id IS NULL;

-- 26. Check that the PEP alert links to this review
SELECT
    COUNT(*) AS mismatched_alerts
FROM screening_alerts s
LEFT JOIN kyc_reviews r ON s.review_id = r.review_id
WHERE s.client_id = 1877
  AND (r.review_id IS NULL OR s.client_id <> r.client_id);

-- 27. Check that the EDD record links to this review
SELECT
    COUNT(*) AS mismatched_edd_records
FROM edd_reviews e
LEFT JOIN kyc_reviews r ON e.review_id = r.review_id
WHERE e.client_id = 1877
  AND (r.review_id IS NULL OR e.client_id <> r.client_id);
