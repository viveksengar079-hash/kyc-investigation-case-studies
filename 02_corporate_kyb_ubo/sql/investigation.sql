-- Case Study 02: Corporate KYB and UBO review
-- Client: 121 | Review: REV-00121
-- Training data only. The queries only read existing data.
-- The company and ownership evidence are synthetic; nothing is approved here.

USE kyc_case_studies;

-- Case intake and company profile

-- 1. Assigned company review
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
WHERE r.client_id = 121;

-- 2. Customer risk indicators
SELECT
    client_id,
    client_name,
    client_type,
    sector,
    sector_risk,
    country,
    pep_flag,
    sanctions_flag,
    sectoral_sanctions_flag,
    ownership_opacity_score
FROM clients_master
WHERE client_id = 121;

-- 3. Business registration details
SELECT
    client_id,
    legal_name,
    entity_type,
    registration_number,
    registration_country,
    business_activity,
    business_purpose,
    registration_verified
FROM kyb_entities
WHERE client_id = 121;

-- 4. Company profile
SELECT
    client_id,
    incorporation_date,
    registered_address,
    relationship_start_date,
    relationship_status
FROM customer_profiles
WHERE client_id = 121;


-- Documents and business address

-- 5. Documents in the file
SELECT
    document_id,
    document_type,
    document_reference,
    holder_name,
    issue_date,
    expiry_date,
    address_on_document,
    verification_status
FROM kyc_documents
WHERE client_id = 121
ORDER BY document_type;

-- 6. Company name on documents
SELECT
    d.document_type,
    e.legal_name,
    d.holder_name,
    CASE
        WHEN d.holder_name = e.legal_name THEN 'MATCH'
        ELSE 'CHECK_NAME'
    END AS name_check
FROM kyc_documents d
JOIN kyb_entities e ON d.client_id = e.client_id
WHERE d.client_id = 121;

-- 7. Registered address versus proof
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
WHERE p.client_id = 121
  AND d.document_type = 'BUSINESS_ADDRESS_PROOF';


-- Ownership and beneficial owners

-- 8. Direct owners of the company
SELECT
    owner_name,
    owner_type,
    owner_entity_id,
    ownership_pct,
    evidence_status
FROM ownership_links
WHERE client_id = 121
  AND parent_entity_id = 'CLIENT-121'
ORDER BY ownership_pct DESC;

-- 9. Owners of the holding company
SELECT
    owner_name,
    owner_type,
    owner_entity_id,
    ownership_pct,
    evidence_status
FROM ownership_links
WHERE client_id = 121
  AND parent_entity_id = 'HOLDCO-121'
ORDER BY owner_name;

-- 10. Ownership totals at each level
SELECT
    parent_entity_id,
    SUM(ownership_pct) AS total_ownership_pct
FROM ownership_links
WHERE client_id = 121
GROUP BY parent_entity_id
ORDER BY parent_entity_id;

-- 11. Direct individual shareholder
SELECT
    owner_name,
    ownership_pct AS effective_ownership_pct,
    evidence_status
FROM ownership_links
WHERE client_id = 121
  AND parent_entity_id = 'CLIENT-121'
  AND owner_type = 'INDIVIDUAL';

-- 12. Calculate indirect ownership
SELECT
    child.owner_name,
    parent.ownership_pct AS holding_company_share,
    child.ownership_pct AS share_in_holding_company,
    ROUND(parent.ownership_pct * child.ownership_pct / 100, 2) AS effective_ownership_pct
FROM ownership_links parent
JOIN ownership_links child
    ON parent.owner_entity_id = child.parent_entity_id
WHERE parent.client_id = 121
  AND child.client_id = 121
  AND parent.parent_entity_id = 'CLIENT-121'
  AND parent.owner_type = 'ENTITY'
ORDER BY child.owner_name;

-- 13. Recorded beneficial owners
SELECT
    person_id,
    person_name,
    effective_ownership_pct,
    ubo_25pct_indicator,
    verification_status,
    calculation_method
FROM beneficial_owners
WHERE client_id = 121
ORDER BY effective_ownership_pct DESC, person_id;

-- 14. Unverified beneficial owners
SELECT
    person_id,
    person_name,
    effective_ownership_pct,
    verification_status
FROM beneficial_owners
WHERE client_id = 121
  AND verification_status <> 'VERIFIED';


-- Screening and adverse media

-- 15. Recorded screening alerts
SELECT
    COUNT(*) AS recorded_screening_alerts
FROM screening_alerts
WHERE client_id = 121;

-- 16. Adverse-media leads in the pack
SELECT
    media_id,
    headline,
    alleged_issue,
    source_name,
    name_match_only,
    disposition,
    independent_verification
FROM adverse_media_hits
WHERE client_id = 121;


-- Financial profile, risk and EDD

-- 17. Declared financial background
SELECT
    annual_revenue_scu,
    source_of_funds,
    source_of_wealth,
    expected_monthly_value_scu,
    expected_monthly_txn_count,
    expected_counterparty_countries,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 121;

-- 18. Draft customer risk assessment
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
WHERE client_id = 121;

-- 19. Enhanced due diligence status
SELECT
    edd_id,
    reason,
    source_of_funds_verification,
    source_of_wealth_verification,
    management_approval,
    edd_status
FROM edd_reviews
WHERE client_id = 121;


-- Information requests and case status

-- 20. Requests for missing evidence
SELECT
    request_id,
    request_type,
    request_reason,
    requested_date,
    due_date,
    request_status
FROM information_requests
WHERE client_id = 121
ORDER BY request_id;

-- 21. Count overdue requests
SELECT
    COUNT(*) AS overdue_requests
FROM information_requests
WHERE client_id = 121
  AND request_status = 'OVERDUE';

-- 22. Quality review findings
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 121;

-- 23. Case activity history
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 121
ORDER BY event_date;

-- 24. Current case status
SELECT
    r.review_id,
    r.status AS review_status,
    a.assessment_status,
    e.edd_status
FROM kyc_reviews r
LEFT JOIN risk_assessments a ON r.review_id = a.review_id
LEFT JOIN edd_reviews e ON r.review_id = e.review_id
WHERE r.client_id = 121;


-- Final data checks

-- 25. Check ownership references
SELECT
    COUNT(*) AS unmatched_ownership_records
FROM ownership_links o
LEFT JOIN clients_master c ON o.client_id = c.client_id
WHERE o.client_id = 121
  AND c.client_id IS NULL;

-- 26. Check UBO references
SELECT
    COUNT(*) AS unmatched_ubo_records
FROM beneficial_owners b
LEFT JOIN clients_master c ON b.client_id = c.client_id
WHERE b.client_id = 121
  AND c.client_id IS NULL;

-- Case note:
-- The three recorded individuals have calculated shares of 40%, 30% and 30%.
-- Ownership records, registration and UBO identities still need verification.
-- The MEDIUM risk band is only a training draft, not a final bank decision.
-- Leave the review IN_PROGRESS and follow up on overdue information requests.
