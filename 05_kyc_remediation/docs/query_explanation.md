# Case Study 5 — SQL Query Explanations

I used these queries to review a KYC file with an expired identity document and an overdue information request. I kept the SQL simple, because the focus is the investigation rather than complex coding.

**Reference date:** 18 November 2026. I used this date in the deadline checks so the results stay the same when I rerun the file later.

## Case intake and customer details

### Query 1 — Check the assigned remediation review

**What:** Read the review assignment and deadline.

**Why:** Make sure I am working on the correct customer and review.

**When:** When I receive a KYC remediation or periodic-review case.

**What I found:** The review is periodic, in progress, and due on 5 November 2026.

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
WHERE r.client_id = 1085;
```

### Query 2 — Check the original customer risk indicators

**What:** Read the customer category and recorded risk flags.

**Why:** Understand whether any customer information needs extra attention.

**When:** During the first customer-profile review.

**What I found:** Sector is Energy/Oil with High sector risk; the sectoral-sanctions flag is 1, but the general sanctions flag is 0. Neither is proof of an actual sanctions match.

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
    sectoral_sanctions_flag
FROM clients_master
WHERE client_id = 1085;
```

### Query 3 — Review the customer profile on file

**What:** See the personal information recorded for the customer.

**Why:** Check what is already on file before asking for more documents.

**When:** At the start of the document review.

**What I found:** The simulated profile is active and lists a residential address in Indore. The data does not show a customer-name review flag.

**SQL**
```sql
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
```

### Query 4 — Check the account relationship

**What:** Confirm whether the customer has an existing relationship.

**Why:** Avoid confusing this periodic review with new onboarding.

**When:** During case intake.

**What I found:** The simulated personal account is active.

**SQL**
```sql
SELECT
    account_id,
    account_type,
    open_date,
    account_status
FROM accounts
WHERE client_id = 1085;
```

### Query 5 — Check how late the review is

**What:** Compare the review deadline with our fixed reference date.

**Why:** See whether the KYC review needs follow-up or priority attention.

**When:** When checking review deadlines and backlog.

**What I found:** The review due date was 5 November 2026, so it is 13 days overdue on 18 November.

**SQL**
```sql
SELECT
    review_id,
    due_date,
    status,
    DATEDIFF('2026-11-18', due_date) AS days_overdue
FROM kyc_reviews
WHERE client_id = 1085;
```

## Document exceptions

### Query 6 — List all customer documents

**What:** List the identity and address documents.

**Why:** See the exact records available instead of guessing what is missing.

**When:** Before deciding which documents need refreshing.

**What I found:** The passport is marked expired; the address proof is marked verified.

**SQL**
```sql
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
```

### Query 7 — Check document expiry dates

**What:** Compare recorded expiry dates with the review date.

**Why:** Separate an expired document from one that does not have a recorded expiry.

**When:** During document-validity checks.

**What I found:** The passport expired on 1 March 2025; the address proof has no expiry date recorded, which does not by itself establish freshness.

**SQL**
```sql
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
```

### Query 8 — Compare names on documents

**What:** Check whether the recorded names are consistent.

**Why:** Spot obvious name differences that would need clarification.

**When:** During identity and address document review.

**What I found:** Both simulated document names match the database name exactly. That does not authenticate the documents or resolve whether the customer classification is accurate.

**SQL**
```sql
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
```

### Query 9 — Compare customer and proof addresses

**What:** Compare the address on file with the address proof.

**Why:** Identify whether we need to ask about an address mismatch.

**When:** During the address verification check.

**What I found:** The simulated addresses match, and the address proof is recorded as verified.

**SQL**
```sql
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
```

### Query 10 — Find documents that need attention

**What:** Filter for documents with a non-verified status or exception code.

**Why:** Keep the remediation list focused on actual record-level issues.

**When:** After the full document review.

**What I found:** One passport appears as an exception; the address proof is not an open document exception.

**SQL**
```sql
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
```

### Query 11 — Count document verification statuses

**What:** Count how many documents are in each recorded status.

**Why:** Make the document review easy to summarize in a case note.

**When:** When documenting outstanding exceptions.

**What I found:** One EXPIRED and one VERIFIED document are recorded.

**SQL**
```sql
SELECT
    verification_status,
    COUNT(*) AS document_count
FROM kyc_documents
WHERE client_id = 1085
GROUP BY verification_status
ORDER BY verification_status;
```

## Information request and follow-up

### Query 12 — Read the document-refresh request

**What:** Review exactly what was requested from the customer.

**Why:** Avoid sending a duplicate request and understand what is still outstanding.

**When:** After confirming the passport exception.

**What I found:** There is one document-refresh request, marked OVERDUE, with no response date.

**SQL**
```sql
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
```

### Query 13 — Calculate the request delay

**What:** Measure how far past the request due date we are.

**Why:** Support appropriate follow-up and reporting.

**When:** When the request is still outstanding.

**What I found:** The request was due on 1 November 2026, making it 17 days overdue on the reference date.

**SQL**
```sql
SELECT
    request_id,
    due_date,
    request_status,
    DATEDIFF('2026-11-18', due_date) AS days_overdue
FROM information_requests
WHERE client_id = 1085;
```

### Query 14 — Compare request and review deadlines

**What:** Read the request timing next to the KYC review deadline.

**Why:** Check whether the information was requested early enough to allow follow-up.

**When:** During overdue-case review.

**What I found:** The document request was raised 15 days before the KYC deadline. We cannot infer that the follow-up was sufficient without contact records.

**SQL**
```sql
SELECT
    r.review_id,
    r.due_date AS review_due_date,
    i.requested_date,
    i.due_date AS request_due_date,
    DATEDIFF(r.due_date, i.requested_date) AS days_before_review_due
FROM kyc_reviews r
JOIN information_requests i ON r.review_id = i.review_id
WHERE r.client_id = 1085;
```

### Query 15 — Read actions already recorded

**What:** Look at the timeline of recorded case actions.

**Why:** Understand what the analyst has already done before recommending a follow-up.

**When:** Before writing the remediation summary.

**What I found:** The training history records case opening and an information request, but no documented customer response.

**SQL**
```sql
SELECT
    event_date,
    event_type,
    notes,
    actor
FROM case_events
WHERE client_id = 1085
ORDER BY event_date;
```

### Query 16 — View the request next to the expired passport

**What:** Compare the request and the specific identity document.

**Why:** Confirm that the requested refresh relates to a real document exception.

**When:** When deciding the next action on the request.

**What I found:** The overdue refresh request relates to a passport that is recorded as expired.

**SQL**
```sql
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
```

## Risk context and additional checks

### Query 17 — Check whether screening alert records exist

**What:** Check for any screening-alert records in the training pack.

**Why:** Avoid saying the customer is clear just because a sanctions flag is zero.

**When:** While checking whether other issues affect KYC completion.

**What I found:** No screening alert row is present. This does not prove that screening was completed or cleared.

**SQL**
```sql
SELECT
    alert_id,
    screening_type,
    candidate_name,
    alert_status
FROM screening_alerts
WHERE client_id = 1085;
```

### Query 18 — Read the declared financial profile

**What:** Review the financial background already recorded.

**Why:** Know what is self-declared before deciding whether more supporting evidence is necessary.

**When:** When reviewing customer-risk context during remediation.

**What I found:** The source-of-funds information is SELF_DECLARED, not independently verified.

**SQL**
```sql
SELECT
    profile_effective_date,
    source_of_funds,
    source_of_wealth,
    funding_information_status,
    declared_unit
FROM customer_financial_profiles
WHERE client_id = 1085;
```

### Query 19 — Review the draft customer risk assessment

**What:** Read the recorded risk proposal and its status.

**Why:** Avoid relying on a training score as though it were an approved bank risk rating.

**When:** Before recommending whether the file is ready to close.

**What I found:** The proposed customer band is MEDIUM, but the assessment status is TRAINING_PRELIMINARY.

**SQL**
```sql
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
```

### Query 20 — Check whether draft rating needs review

**What:** Flag the difference between sector risk and overall draft customer rating.

**Why:** Check whether the proposed rating has a valid rationale.

**When:** During risk-assessment quality review.

**What I found:** The result requests review; a High sector does not automatically mean the overall customer must be High.

**SQL**
```sql
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
```

### Query 21 — Check whether an EDD review exists

**What:** Look for an enhanced due diligence case record.

**Why:** Separate an absent row from a documented decision that EDD was not required.

**When:** When risk factors suggest further due diligence may be needed.

**What I found:** No EDD record is present in this synthetic pack. EDD applicability needs policy-based consideration.

**SQL**
```sql
SELECT
    edd_id,
    reason,
    edd_status
FROM edd_reviews
WHERE client_id = 1085;
```

## QA, case status and relationship checks

### Query 22 — Review the QA entry

**What:** See whether the training case has any QA review outstanding.

**Why:** Do not claim a QC defect where none was recorded.

**When:** Before submitting the remediation case for closure.

**What I found:** QA is PENDING, but its finding is blank and correction_required is NO; this is not evidence of a confirmed QA defect.

**SQL**
```sql
SELECT
    qa_id,
    qa_date,
    qa_status,
    finding,
    correction_required
FROM qa_reviews
WHERE client_id = 1085;
```

### Query 23 — Summarize current record statuses

**What:** See the review, request, document, risk and QA statuses together.

**Why:** Make sure the written conclusion matches the actual records.

**When:** Just before writing the final case note.

**What I found:** Review is IN_PROGRESS, request OVERDUE, passport EXPIRED, rating preliminary, and QA PENDING.

**SQL**
```sql
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
```

### Query 24 — Check that documents belong to a known customer

**What:** Find any documents whose customer ID is missing from the master table.

**Why:** Avoid linking an exception to an invalid customer record.

**When:** During data checks for the case-study environment.

**What I found:** No unmatched document records were found.

**SQL**
```sql
SELECT
    COUNT(*) AS unmatched_documents
FROM kyc_documents d
LEFT JOIN clients_master c ON d.client_id = c.client_id
WHERE d.client_id = 1085
  AND c.client_id IS NULL;
```

### Query 25 — Check that requests belong to the correct review

**What:** Count requests with a missing or wrongly linked review.

**Why:** Keep our case evidence connected to the right review ID.

**When:** During pre-report data checks.

**What I found:** No mismatched information-request records were found.

**SQL**
```sql
SELECT
    COUNT(*) AS mismatched_requests
FROM information_requests i
LEFT JOIN kyc_reviews r ON i.review_id = r.review_id
WHERE i.client_id = 1085
  AND (r.review_id IS NULL OR r.client_id <> i.client_id);
```

### Query 26 — Check that QA belongs to the correct review

**What:** Count QA records not attached to the correct KYC review.

**Why:** Prevent an incorrect QA finding from being attributed to this customer.

**When:** During pre-report data checks.

**What I found:** No mismatched QA records were found.

**SQL**
```sql
SELECT
    COUNT(*) AS mismatched_qa_records
FROM qa_reviews q
LEFT JOIN kyc_reviews r ON q.review_id = r.review_id
WHERE q.client_id = 1085
  AND (r.review_id IS NULL OR r.client_id <> q.client_id);
```
