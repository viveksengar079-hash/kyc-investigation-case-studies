

USE kyc_case_studies;


-- Case intake

-- 1. Check the assigned periodic review
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
WHERE r.client_id = 36;

-- 2. Review the customer risk flags
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
WHERE client_id = 36;

-- 3. Read the current customer profile
SELECT
    client_id,
    date_of_birth,
    occupation,
    registered_address,
    relationship_start_date,
    relationship_status
FROM customer_profiles
WHERE client_id = 36;

-- 4. Check how overdue the periodic review is
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF('2026-11-18', due_date) AS days_past_due
FROM kyc_reviews
WHERE client_id = 36;


-- Identity and address evidence

-- 5. List the KYC documents
SELECT
    document_id,
    document_type,
    holder_name,
    issue_date,
    expiry_date,
    verification_status,
    discrepancy_code
FROM kyc_documents
WHERE client_id = 36
ORDER BY document_type;

-- 6. Check document expiry separately from verification
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
WHERE client_id = 36
ORDER BY document_type;

-- 7. Compare names on the documents
SELECT
    d.document_type,
    c.client_name AS customer_name,
    d.holder_name AS document_name,
    CASE
        WHEN d.holder_name = c.client_name THEN 'NAME_MATCH'
        ELSE 'CHECK_NAME'
    END AS name_check
FROM kyc_documents d
JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 36
ORDER BY d.document_type;

-- 8. Compare the recorded and proof addresses
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
WHERE p.client_id = 36
  AND d.document_type = 'ADDRESS_PROOF';

-- 9. Check the document-refresh request against the passport record
SELECT
    i.request_type,
    i.request_reason,
    i.request_status,
    d.document_type,
    d.expiry_date,
    d.verification_status
FROM information_requests i
JOIN kyc_documents d ON i.client_id = d.client_id
WHERE i.client_id = 36
  AND d.document_type = 'PASSPORT';


-- Request follow-up and case history

-- 10. Review the outstanding information request
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status,
    response_date
FROM information_requests
WHERE client_id = 36;

-- 11. Calculate the request delay
SELECT
    request_id,
    due_date,
    request_status,
    DATEDIFF('2026-11-18', due_date) AS days_past_due
FROM information_requests
WHERE client_id = 36;

-- 12. Compare the request date with the review deadline
SELECT
    r.review_id,
    r.due_date AS review_due_date,
    i.requested_date,
    DATEDIFF(i.requested_date, r.due_date) AS days_requested_after_due
FROM kyc_reviews r
JOIN information_requests i ON r.review_id = i.review_id
WHERE r.client_id = 36;

-- 13. Read the case event history
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 36
ORDER BY event_date;


-- Financial background and customer risk

-- 14. Check the recorded source of funds and expected activity
SELECT
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
WHERE client_id = 36;

-- 15. Check whether the customer description needs clarification
SELECT
    c.client_name,
    c.client_type,
    c.sector,
    c.sector_risk,
    p.occupation
FROM clients_master c
JOIN customer_profiles p ON c.client_id = p.client_id
WHERE c.client_id = 36;

-- 16. Check for screening alerts recorded in the pack
SELECT
    alert_id,
    screening_type,
    candidate_name,
    alert_status
FROM screening_alerts
WHERE client_id = 36;

-- 17. Read the draft risk assessment
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
WHERE client_id = 36;

-- 18. Compare sector risk with the draft customer rating
SELECT
    c.sector_risk,
    a.proposed_risk_band,
    a.assessment_status,
    CASE
        WHEN c.sector_risk = 'High' AND a.proposed_risk_band = 'MEDIUM'
            THEN 'REVIEW_RATING'
        ELSE 'CHECK_POLICY'
    END AS rating_check
FROM clients_master c
JOIN risk_assessments a ON c.client_id = a.client_id
WHERE c.client_id = 36;


-- EDD, QA and current status

-- 19. Check whether an EDD record exists
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 36;

-- 20. Review the QA finding
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 36;

-- 21. Count information requests not yet closed
SELECT
    COUNT(*) AS outstanding_requests
FROM information_requests
WHERE client_id = 36
  AND request_status IN ('OPEN', 'OVERDUE');

-- 22. Check the review, risk and QA statuses together
SELECT
    r.review_id,
    r.status AS review_status,
    a.assessment_status,
    q.qa_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN qa_reviews q ON r.review_id = q.review_id
WHERE r.client_id = 36;

-- 23. Count documents not marked verified
SELECT
    COUNT(*) AS documents_not_verified
FROM kyc_documents
WHERE client_id = 36
  AND verification_status <> 'VERIFIED';


-- Basic data checks

-- 24. Check documents are linked to a customer
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 36
  AND c.client_id IS NULL;

-- 25. Check the information request belongs to the correct review
SELECT
    COUNT(*) AS mismatched_requests
FROM information_requests i
LEFT JOIN kyc_reviews r ON i.review_id = r.review_id
WHERE i.client_id = 36
  AND (r.review_id IS NULL OR i.client_id <> r.client_id);

-- 26. Check the QA finding belongs to the correct review
SELECT
    COUNT(*) AS mismatched_qa_records
FROM qa_reviews q
LEFT JOIN kyc_reviews r ON q.review_id = r.review_id
WHERE q.client_id = 36
  AND (r.review_id IS NULL OR q.client_id <> r.client_id);

-- Note: This case stays open pending customer follow-up, QA correction and risk review.
-- No EDD record is present for client 36. Do not describe EDD as completed.
