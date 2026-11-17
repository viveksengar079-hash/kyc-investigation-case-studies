-- Case Study 05: KYC Remediation and Document Exceptions
-- Customer 1085 | Review REV-01085
-- Synthetic training case. Queries only read data and do not change records.
-- Fixed date for consistent overdue results: 2026-11-18

USE kyc_case_studies;

-- Case intake and customer details
-- 1. Check the assigned remediation review
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
WHERE r.client_id = 1085;

-- 2. Check the original customer risk indicators
SELECT
    client_id,
    client_name,
    client_type,
    country,
    sector,
    sector_risk,
    pep_flag,
    sanctions_flag,
    sectoral_sanctions_flag
FROM clients_master
WHERE client_id = 1085;

-- 3. Review the customer profile on file
SELECT
    client_id,
    date_of_birth,
    occupation,
    registered_address,
    relationship_start_date,
    relationship_status,
    name_review_needed
FROM customer_profiles
WHERE client_id = 1085;

-- 4. Check the account relationship
SELECT
    account_id,
    account_type,
    open_date,
    account_status
FROM accounts
WHERE client_id = 1085;

-- 5. Check how late the review is
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF('2026-11-18', due_date) AS days_overdue
FROM kyc_reviews
WHERE client_id = 1085;


-- Document exceptions
-- 6. List all customer documents
SELECT
    document_id,
    document_type,
    holder_name,
    issue_date,
    expiry_date,
    verification_status,
    discrepancy_code
FROM kyc_documents
WHERE client_id = 1085
ORDER BY document_type;

-- 7. Check document expiry dates
SELECT
    document_type,
    expiry_date,
    verification_status,
    CASE
        WHEN expiry_date IS NULL THEN 'NO_EXPIRY_RECORDED'
        WHEN expiry_date < '2026-11-18' THEN 'EXPIRED'
        ELSE 'NOT_EXPIRED'
    END AS expiry_check
FROM kyc_documents
WHERE client_id = 1085
ORDER BY document_type;

-- 8. Compare names on documents
SELECT
    d.document_type,
    c.client_name AS customer_name,
    d.holder_name AS document_name,
    CASE
        WHEN c.client_name = d.holder_name THEN 'MATCH'
        ELSE 'CHECK_NAME'
    END AS name_check
FROM kyc_documents d
JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1085
ORDER BY d.document_type;

-- 9. Compare customer and proof addresses
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
WHERE p.client_id = 1085
  AND d.document_type = 'ADDRESS_PROOF';

-- 10. Find documents that need attention
SELECT
    document_id,
    document_type,
    verification_status,
    discrepancy_code
FROM kyc_documents
WHERE client_id = 1085
  AND (
      verification_status <> 'VERIFIED'
      OR discrepancy_code IS NOT NULL
  );

-- 11. Count document verification statuses
SELECT
    verification_status,
    COUNT(*) AS document_count
FROM kyc_documents
WHERE client_id = 1085
GROUP BY verification_status
ORDER BY verification_status;


-- Information request and follow-up
-- 12. Read the document-refresh request
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status,
    response_date
FROM information_requests
WHERE client_id = 1085;

-- 13. Calculate the request delay
SELECT
    request_id,
    due_date,
    request_status,
    DATEDIFF('2026-11-18', due_date) AS days_overdue
FROM information_requests
WHERE client_id = 1085;

-- 14. Compare request and review deadlines
SELECT
    r.review_id,
    r.due_date AS review_due_date,
    i.requested_date,
    i.due_date AS request_due_date,
    DATEDIFF(r.due_date, i.requested_date) AS days_before_review_due
FROM kyc_reviews r
JOIN information_requests i ON r.review_id = i.review_id
WHERE r.client_id = 1085;

-- 15. Read actions already recorded
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 1085
ORDER BY event_date;

-- 16. View the request next to the expired passport
SELECT
    i.request_id,
    i.request_type,
    i.request_status,
    d.document_type,
    d.expiry_date,
    d.verification_status
FROM information_requests i
JOIN kyc_documents d ON i.client_id = d.client_id
WHERE i.client_id = 1085
  AND d.document_type = 'PASSPORT';


-- Risk context and additional checks
-- 17. Check whether screening alert records exist
SELECT
    alert_id,
    screening_type,
    candidate_name,
    alert_status
FROM screening_alerts
WHERE client_id = 1085;

-- 18. Read the declared financial profile
SELECT
    profile_effective_date,
    source_of_funds,
    source_of_wealth,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 1085;

-- 19. Review the draft customer risk assessment
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
WHERE client_id = 1085;

-- 20. Check whether draft rating needs review
SELECT
    c.sector_risk,
    a.proposed_risk_band,
    a.assessment_status,
    CASE
        WHEN c.sector_risk = 'High' AND a.proposed_risk_band = 'MEDIUM'
            THEN 'REVIEW_DRAFT_RATING'
        ELSE 'CHECK_POLICY'
    END AS rating_check
FROM clients_master c
JOIN risk_assessments a ON c.client_id = a.client_id
WHERE c.client_id = 1085;

-- 21. Check whether an EDD review exists
SELECT
    edd_id,
    reason,
    edd_status
FROM edd_reviews
WHERE client_id = 1085;


-- QA, case status and relationship checks
-- 22. Review the QA entry
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 1085;

-- 23. Summarize current record statuses
SELECT
    r.review_id,
    r.status AS review_status,
    i.request_status,
    d.verification_status AS passport_status,
    a.assessment_status,
    q.qa_status
FROM kyc_reviews r
LEFT JOIN information_requests i ON r.review_id = i.review_id
LEFT JOIN kyc_documents d ON r.client_id = d.client_id
    AND d.document_type = 'PASSPORT'
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN qa_reviews q ON r.review_id = q.review_id
WHERE r.client_id = 1085;

-- 24. Check that documents belong to a known customer
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1085
  AND c.client_id IS NULL;

-- 25. Check that requests belong to the correct review
SELECT
    COUNT(*) AS mismatched_requests
FROM information_requests i
LEFT JOIN kyc_reviews r ON i.review_id = r.review_id
WHERE i.client_id = 1085
  AND (r.review_id IS NULL OR r.client_id <> i.client_id);

-- 26. Check that QA belongs to the correct review
SELECT
    COUNT(*) AS mismatched_qa_records
FROM qa_reviews q
LEFT JOIN kyc_reviews r ON q.review_id = r.review_id
WHERE q.client_id = 1085
  AND (r.review_id IS NULL OR r.client_id <> q.client_id);

