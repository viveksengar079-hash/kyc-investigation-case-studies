-- Case Study 07: New Customer Onboarding & KYC Decision
-- Client 2001 | Review REV-02001
-- Synthetic training data. These queries only read records.
-- Reference date for the deadline calculation: 2026-11-18

USE kyc_case_studies;

-- Application intake and applicant profile

-- 1. Review the new application
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
WHERE r.client_id = 2001;

-- 2. Check basic applicant information
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
WHERE client_id = 2001;

-- 3. Review the applicant declaration
SELECT
    client_id,
    date_of_birth,
    occupation,
    registered_address,
    application_date,
    relationship_start_date,
    relationship_status,
    record_origin
FROM customer_profiles
WHERE client_id = 2001;

-- 4. Check whether an account has opened
SELECT
    account_id,
    account_type,
    open_date,
    account_status
FROM accounts
WHERE client_id = 2001;

-- 5. Check the onboarding deadline
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF(due_date, '2026-11-18') AS days_until_due
FROM kyc_reviews
WHERE client_id = 2001;

-- Identity and address checks

-- 6. List identity and address documents
SELECT
    document_id,
    document_type,
    holder_name,
    issue_date,
    expiry_date,
    address_on_document,
    verification_status
FROM kyc_documents
WHERE client_id = 2001
ORDER BY document_type;

-- 7. Compare the names on documents
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
WHERE d.client_id = 2001
ORDER BY d.document_type;

-- 8. Check the passport expiry separately
SELECT
    document_id,
    expiry_date,
    verification_status,
    CASE
        WHEN expiry_date < '2026-11-18' THEN 'EXPIRED'
        ELSE 'NOT_EXPIRED'
    END AS expiry_check
FROM kyc_documents
WHERE client_id = 2001
  AND document_type = 'PASSPORT';

-- 9. Compare declared and proof addresses
SELECT
    p.registered_address AS declared_address,
    d.address_on_document AS proof_address,
    d.verification_status,
    CASE
        WHEN p.registered_address = d.address_on_document THEN 'ADDRESS_MATCH'
        ELSE 'CHECK_ADDRESS'
    END AS address_check
FROM customer_profiles p
JOIN kyc_documents d ON p.client_id = d.client_id
WHERE p.client_id = 2001
  AND d.document_type = 'ADDRESS_PROOF';

-- 10. Count pending document checks
SELECT
    COUNT(*) AS total_documents,
    SUM(CASE WHEN verification_status = 'PENDING' THEN 1 ELSE 0 END) AS pending_documents
FROM kyc_documents
WHERE client_id = 2001;

-- Financial profile

-- 11. Review stated income and expected activity
SELECT
    annual_income_scu,
    source_of_funds,
    source_of_wealth,
    expected_monthly_value_scu,
    expected_monthly_txn_count,
    expected_counterparty_countries,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 2001;

-- 12. Check whether funding details are verified
SELECT
    source_of_funds,
    source_of_wealth,
    funding_information_status,
    CASE
        WHEN funding_information_status = 'VERIFIED' THEN 'RECORDED_AS_VERIFIED'
        ELSE 'DECLARATION_ONLY'
    END AS evidence_check
FROM customer_financial_profiles
WHERE client_id = 2001;

-- Screening evidence

-- 13. Check the applicant screening indicators
SELECT
    client_id,
    pep_flag,
    sanctions_flag,
    fatf_country_flag,
    ofac_country_flag
FROM clients_master
WHERE client_id = 2001;

-- 14. Look for screening-alert records
SELECT
    alert_id,
    screening_type,
    candidate_name,
    screening_source,
    alert_status
FROM screening_alerts
WHERE client_id = 2001;

-- 15. Look for a logged screening search
SELECT
    search_id,
    provider,
    search_name,
    search_date,
    reported_result,
    evidence_status
FROM screening_search_log
WHERE client_id = 2001;

-- 16. Look for an adverse-media record
SELECT
    media_id,
    headline,
    alleged_issue,
    publication_date,
    disposition
FROM adverse_media_hits
WHERE client_id = 2001;

-- Risk, requests and QA

-- 17. Review the preliminary risk rating
SELECT
    assessment_id,
    sector_risk,
    pep_indicator,
    sanctions_indicator,
    simulated_risk_score,
    proposed_risk_band,
    assessment_status,
    scoring_method
FROM risk_assessments
WHERE client_id = 2001;

-- 18. Check existing requests for information
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 2001;

-- 19. Review the recorded case activity
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 2001
ORDER BY event_date;

-- 20. Review the open QA issue
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 2001;

-- Onboarding decision readiness

-- 21. Check whether transactions exist for the applicant
SELECT
    COUNT(*) AS recorded_transactions
FROM transactions
WHERE client_id = 2001;

-- 22. Check the application, account, risk and QA together
SELECT
    r.review_id,
    r.status AS review_status,
    a.account_status,
    k.assessment_status,
    q.qa_status
FROM kyc_reviews r
LEFT JOIN accounts a ON r.client_id = a.client_id
LEFT JOIN risk_assessments k ON r.review_id = k.review_id
LEFT JOIN qa_reviews q ON r.review_id = q.review_id
WHERE r.client_id = 2001;

-- Basic integrity checks

-- 23. Check document links
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 2001
  AND c.client_id IS NULL;

-- 24. Check risk-assessment links
SELECT
    COUNT(*) AS mismatched_risk_records
FROM risk_assessments a
LEFT JOIN kyc_reviews r ON a.review_id = r.review_id
WHERE a.client_id = 2001
  AND (r.review_id IS NULL OR r.client_id <> a.client_id);

-- 25. Check QA links
SELECT
    COUNT(*) AS mismatched_qa_records
FROM qa_reviews q
LEFT JOIN kyc_reviews r ON q.review_id = r.review_id
WHERE q.client_id = 2001
  AND (r.review_id IS NULL OR r.client_id <> q.client_id);
