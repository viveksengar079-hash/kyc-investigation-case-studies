# Case Study 3 — PEP, Sanctions and Adverse-Media Screening

**Customer:** Hoffman-Frost (`client_id = 341`)  
**Review ID:** REV-00341  
**Review type:** Event-driven PEP review  
**Review status:** PENDING_CUSTOMER  
**Data:** Original Kaggle customer record with **fictional** KYC and screening evidence

## Why I worked on this case

I used this training case to understand how an L1 analyst reviews a PEP alert instead of assuming that a high name-similarity score means a true match. My focus was on checking identifiers, understanding the screening source, looking at any supporting adverse-media information and recording what still needs verification.

## Case intake

The source customer record lists Hoffman-Frost as an individual in Japan, associated with Import/Export. It has a PEP flag of 1 and a sanctions flag of 0. The simulated case is high priority, opened on 10 October 2026, and was due on 10 November 2026. Its recorded status is `PENDING_CUSTOMER`.

I treated the flags as reasons to investigate, not as proof that the customer is a PEP or is sanctioned.

## Identity and document review

The simulated profile provides a date of birth of **18 June 1992**. There are two document records. The name matches the customer record on both, but the passport is marked **EXPIRED** with an expiry date of **1 March 2025**. The address proof is marked VERIFIED and its recorded address matches the profile.

The name and address comparisons only check whether our **training rows agree**. They do not authenticate an actual passport or verify an address in the real world. I would refer the expired identity document for refresh under the applicable CDD procedure.

## PEP alert and identifier comparison

The training database contains one simulated PEP alert: **SCR-00028**. The candidate name, date of birth and country match the customer's simulated details. The alert has HIGH name similarity and is marked OPEN with a recommendation to `REFER_FOR_VERIFICATION`.

This is a stronger potential match than a name-only hit, but **it is not a confirmed PEP match**. The alert source is `SIMULATED_INTERNAL_WATCHLIST`, and the position field says only **“Simulated risk record.”** It does not identify a verified public office, term in office, official source or reliable screening identifiers beyond those we generated.

I would keep the alert open and refer it for verification against approved, reliable screening sources and the bank's PEP policy. I would not call it a true positive or false positive from these records alone.

## Sanctions screening

The original customer-level sanctions flag is 0, and the pack contains no sanctions alert rows or external screening-search log for Client 341. That **does not establish sanctions clearance**. I would check whether approved sanctions screening has actually been completed and documented.

The real Dilisense search previously discussed for Client 1708 belongs to Case Study 1. It is not evidence for Hoffman-Frost.

## Adverse-media review

A fictional media lead, **MED-00341**, mentions a **business licensing issue**. The record is marked `REVIEW_REQUIRED` and `NOT_VERIFIED`, with no real URL. It is also flagged as a name-only lead.

I would not treat that as proof of wrongdoing. I would need a traceable original publication, additional identifiers to connect the person to the report, and a review of its relevance and reliability before including it in a risk decision.

## Financial and customer risk context

The simulated financial profile says professional fees as source of funds and inheritance/investments as source of wealth, but funding information is **UNVERIFIED**. The training figures use **SCU (simulated currency units)** and cannot be presented as yen, rupees or dollars.

The draft risk assessment shows a training score of **4**, proposed band **MEDIUM**, with status `DRAFT_PENDING_REVIEW`. A draft medium rating cannot settle the PEP concern. There is also **no linked EDD review row** in the pack, which means I cannot claim EDD is in progress or complete. Appropriate EDD steps would be assessed if a relevant PEP connection is substantiated, following bank policy.

## Outstanding actions and review status

The case has one PEP-supporting-evidence request, due **1 November 2026** and marked `OVERDUE`. It was **17 days overdue** on the guide's reference date of **18 November 2026**. The KYC review was due on **10 November 2026** and is still `PENDING_CUSTOMER`.

The activity log records case opening and an information request. No separate QA record exists for this client in the supplied pack, so I would not describe the file as QA-approved.

## My recommendation

I would **keep the screening alert and KYC review open**, follow up on the overdue supporting evidence, and refer the potential PEP match for verification against reliable sources. I would also flag the expired passport for KYC remediation and ensure appropriate sanctions screening is evidenced.

I would not close the PEP alert, confirm the media allegation, finalize the customer's risk rating or state that EDD is complete based on this training data. Once the information is available, the responsible reviewer can assess the disposition and any further due diligence under the institution's policy.

**Training-case outcome:** Pending supporting evidence and screening verification; escalation or senior review as required by policy.

## What I learned

This case helped me practise comparing multiple screening identifiers, separating a possible match from a confirmed match, evaluating weak adverse-media evidence, keeping track of overdue requests and writing a cautious L1 recommendation.

*All watchlist entries, media reports, documents and workflow records are fictional. This is a portfolio training exercise, not a real customer investigation.*
