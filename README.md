# Vermont Medicaid PMPM Reconciliation — SFY2022

A PMPM variance analysis using real Vermont Medicaid (DVHA) SFY2022 budget enrollment
and payment rates, with simulated actual enrollment figures to model a realistic
reconciliation scenario. Demonstrates healthcare finance and variance reporting skills
applicable to Medicaid managed care.

> **Data Note:** PMPM rates and budget enrollment figures are sourced directly from the
> Vermont Department of Vermont Health Access (DVHA) SFY2022 Annual PMPM Legislative
> Report (September 15, 2022), prepared by Patrick Rooney, Financial Director IV.
> Actual enrollment and PMPM figures were simulated to model a realistic reconciliation
> scenario against the published budget targets.

## Overview

This project replicates an end-of-period Medicaid PMPM reconciliation as it would be
performed by a managed care analyst — comparing budgeted figures against actuals across
all 13 Vermont Medicaid Eligibility Groups (MEGs), flagging variances exceeding defined
thresholds, and documenting findings and resolutions in a format suitable for state
reporting.

## Key Terms

- **MEG (Medicaid Eligibility Group)** — A classification category used by Vermont
Medicaid to group members by eligibility type. Each MEG has its own PMPM rate
reflecting the expected cost profile of that population.
- **PMPM (Per Member Per Month)** — A standard healthcare finance metric representing
the average cost or payment per enrolled member per month.
- **ABD (Aged, Blind, and Disabled)** — A Medicaid eligibility category covering
individuals who qualify due to age, blindness, or disability.
  - **ABD Adult** — Non-elderly adults qualifying under the ABD category
  - **ABD Dual** — Members enrolled in both Medicaid and Medicare (dual-eligible)
  - **ABD Child** — Children qualifying under the ABD category; typically high-acuity
  with above-average PMPM costs
- **CHIP (Children's Health Insurance Program)** — A federally funded program providing
low-cost health coverage to children in families that earn too much to qualify for Medicaid
- **Choices for Care** — Vermont's Medicaid Home and Community Based Services (HCBS)
waiver program for elderly and disabled adults; one of the highest-cost MEGs
- **PHE (Public Health Emergency)** — Refers to the COVID-19 public health emergency
declaration, which triggered continuous enrollment provisions preventing disenrollment
during SFY2022
- **Capitation/PMPM Rate** — A fixed monthly payment made to managed care organizations
per enrolled member, regardless of actual services used

## Analytical Questions

1. How does actual enrollment compare to budgeted enrollment across all MEGs?
2. Where do PMPM cost variances exist, and what is their financial impact?
3. Which variances exceed defined thresholds and require escalation?
4. What are the root causes of flagged variances, and how are they resolved?
5. What is the total annual budget impact of all enrollment and PMPM variances?

## Methodology

- Variance threshold: PMPM variance >2.0% or enrollment variance >1.0% flagged for review
- Each flagged item includes a finding, root cause analysis, and resolution status
- Escalated items (exceeding threshold) require actuarial referral or budget amendment
- All resolved items documented with analyst initials and date per period-close protocol

## Key Findings

| Metric | Budget | Actual | Variance |
|---|---|---|---|
| Total Members (Avg Monthly) | 191,656 | 192,086 | +430 |
| Total Annual Cost ($) | $726,917,592 | $729,817,175 | +$2,899,583 |
| MEGs Flagged for Review | 0 | 7 | +7 |
| MEGs Escalated (>Threshold) | 0 | 2 | +2 |
| MEGs Resolved | 0 | 5 | +5 |

**Escalated Items:**
- **ABD Child** — PMPM exceeded budget by $24.46 (+2.29%), driven by increased
long-term care and behavioral health claims. Referred to actuarial team.
- **Choices for Care** — Enrollment exceeded projection by 125 members (+2.72%),
generating ~$1.09M in unbudgeted annual costs. Budget amendment submitted.

## Workbook Structure

- **SFY2022 Budget Reference** — Source DVHA data reproduced verbatim
- **Reconciliation Report** — Budget vs. actual comparison across all 13 MEGs
- **Findings & Resolution Log** — Root cause analysis and resolution status per flagged item
- **Summary Dashboard** — Auto-calculated executive summary of reconciliation results

## Tools Used

Excel — financial modeling, variance calculations, reconciliation tables,
conditional formatting, summary dashboard

## Data Source

Vermont Department of Vermont Health Access (DVHA) — SFY2022 Annual PMPM Legislative
Report, September 15, 2022. Submitted by Andrea De La Bruere, Commissioner.
Prepared by Patrick Rooney, Financial Director IV.
