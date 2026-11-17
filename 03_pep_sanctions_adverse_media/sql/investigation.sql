-- Case Study 03: PEP, sanctions and adverse-media screening
-- Client: 341 | Review: REV-00341
-- Synthetic training records only. This script does not change the database.
-- Reference date for overdue/expiry checks: 18 November 2026.

USE kyc_case_studies;


-- Case intake

-- 1. Assigned screening review
SELECT
    r.review_id,
    c.client_name,
    r.review_type,
    r.`trigger`,
    r.opened_date,
    r.due_date,
    r.status,
    r.review_priority
FROM kyc_reviews r
JOIN clients_master c ON r.client_id = c.client_id
WHERE r.client_id = 341;

-- 2. Customer risk flags
SELECT
    client_id,
    client_name,
    client_type,
    country,
    sector,
    sector_risk,
    pep_flag,
    sanctions_flag
FROM clients_master
WHERE client_id = 341;

-- 3. Customer identity details
SELECT
    client_id,
    date_of_birth,
    occupation,
    country,
    registered_address,
    relationship_status
FROM customer_profiles
WHERE client_id = 341;


-- Document checks

-- 4. Available KYC documents
SELECT
    document_id,
    document_type,
    holder_name,
    issue_date,
    expiry_date,
    verification_status
FROM kyc_documents
WHERE client_id = 341
ORDER BY document_type;

-- 5. Name on each document
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
WHERE d.client_id = 341;

-- 6. Passport expiry check
SELECT
    document_type,
    expiry_date,
    verification_status,
    CASE
        WHEN expiry_date IS NULL THEN 'NO_EXPIRY_DATE'
        WHEN expiry_date < '2026-11-18' THEN 'EXPIRED'
        ELSE 'NOT_EXPIRED'
    END AS expiry_check
FROM kyc_documents
WHERE client_id = 341
ORDER BY document_type;

-- 7. Address evidence consistency
SELECT
    p.registered_address,
    d.address_on_document,
    d.verification_status,
    CASE
        WHEN p.registered_address = d.address_on_document THEN 'MATCH'
        ELSE 'CHECK_ADDRESS'
    END AS address_check
FROM customer_profiles p
JOIN kyc_documents d ON p.client_id = d.client_id
WHERE p.client_id = 341
  AND d.document_type = 'ADDRESS_PROOF';


-- Screening investigation

-- 8. PEP screening alert details
SELECT
    alert_id,
    review_id,
    screening_type,
    candidate_name,
    candidate_dob,
    candidate_country,
    candidate_position,
    screening_source,
    name_similarity,
    recommendation,
    alert_status
FROM screening_alerts
WHERE client_id = 341;

-- 9. Compare screening identifiers
SELECT
    a.alert_id,
    a.candidate_name,
    CASE
        WHEN a.candidate_name = c.client_name THEN 'NAME_MATCH'
        ELSE 'CHECK_NAME'
    END AS name_check,
    CASE
        WHEN a.candidate_dob = p.date_of_birth THEN 'DOB_MATCH'
        ELSE 'CHECK_DOB'
    END AS dob_check,
    CASE
        WHEN a.candidate_country = p.country THEN 'COUNTRY_MATCH'
        ELSE 'CHECK_COUNTRY'
    END AS country_check
FROM screening_alerts a
JOIN clients_master c ON a.client_id = c.client_id
JOIN customer_profiles p ON a.client_id = p.client_id
WHERE a.client_id = 341;

-- 10. Alert recommendation and origin
SELECT
    alert_id,
    candidate_position,
    screening_source,
    identifier_comparison,
    recommendation,
    alert_status,
    record_origin
FROM screening_alerts
WHERE client_id = 341;

-- 11. Check recorded sanctions alerts
SELECT
    alert_id,
    screening_type,
    candidate_name,
    alert_status
FROM screening_alerts
WHERE client_id = 341
  AND screening_type = 'SANCTIONS';

-- 12. Check external screening search logs
SELECT
    provider,
    search_name,
    search_date,
    reported_result,
    evidence_status
FROM screening_search_log
WHERE client_id = 341;


-- Adverse media

-- 13. Read the adverse-media lead
SELECT
    media_id,
    headline,
    alleged_issue,
    publication_date,
    source_name,
    disposition
FROM adverse_media_hits
WHERE client_id = 341;

-- 14. Check media verification status
SELECT
    media_id,
    name_match_only,
    url,
    independent_verification,
    record_origin
FROM adverse_media_hits
WHERE client_id = 341;


-- Supporting profile

-- 15. Financial background context
SELECT
    source_of_funds,
    source_of_wealth,
    annual_income_scu,
    expected_monthly_value_scu,
    expected_monthly_txn_count,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 341;


-- Risk and follow-up

-- 16. Draft customer risk assessment
SELECT
    assessment_id,
    pep_indicator,
    sanctions_indicator,
    simulated_risk_score,
    proposed_risk_band,
    assessment_status,
    scoring_method
FROM risk_assessments
WHERE client_id = 341;

-- 17. Enhanced due diligence record
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 341;

-- 18. Outstanding information request
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 341;

-- 19. How long the request is overdue
SELECT
    request_id,
    due_date,
    DATEDIFF('2026-11-18', due_date) AS days_past_due,
    request_status
FROM information_requests
WHERE client_id = 341
  AND due_date < '2026-11-18';


-- Case controls

-- 20. Case action history
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 341
ORDER BY event_date;

-- 21. QA review records
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding
FROM qa_reviews
WHERE client_id = 341;

-- 22. Case status before recommendation
SELECT
    r.review_id,
    r.status AS review_status,
    r.due_date,
    a.proposed_risk_band,
    a.assessment_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
WHERE r.client_id = 341;


-- Data checks

-- 23. Check the screening alert link
SELECT
    COUNT(*) AS unmatched_screening_alerts
FROM screening_alerts a
LEFT JOIN kyc_reviews r ON a.review_id = r.review_id
WHERE a.client_id = 341
  AND (r.review_id IS NULL OR a.client_id <> r.client_id);

-- 24. Check the document link
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 341
  AND c.client_id IS NULL;
