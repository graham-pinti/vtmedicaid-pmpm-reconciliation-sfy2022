# Vermont Medicaid PMPM Reconciliation -- SFY2022

A variance analysis using real Vermont Medicaid (DVHA) SFY2022 budget enrollment and Per Member Per Month (PMPM) payment rates, with simulated actual figures to model a realistic end-of-year reconciliation scenario. Demonstrates healthcare finance, variance reporting, and SQL skills applicable to Medicaid managed care and data analytics roles.

> **Data Note:** PMPM rates and budget enrollment figures are sourced directly from the Vermont Department of Vermont Health Access (DVHA) SFY2022 Annual PMPM Legislative Report (September 15, 2022), prepared by Patrick Rooney, Financial Director IV. Actual enrollment and PMPM figures were simulated to model a realistic reconciliation scenario against the published budget targets.

---

## Overview

This project replicates an end-of-period Medicaid PMPM reconciliation as it would be performed by a managed care analyst -- comparing budgeted figures against actuals across all 13 Vermont Medicaid Eligibility Groups (MEGs, the eligibility categories Vermont uses to classify members and set PMPM rates), flagging variances exceeding defined thresholds, and documenting findings and resolutions in a format suitable for state reporting.

The project is implemented in two layers:
- **Excel** -- financial modeling, variance calculations, conditional formatting, and summary dashboard
- **SQL (PostgreSQL)** -- relational database implementation with analysis queries and a summary view

---

## Key Findings

| Metric | Budget | Actual | Variance |
| --- | --- | --- | --- |
| Total Members (Avg Monthly) | 191,656 | 192,086 | +430 |
| Total Annual Cost | $726,917,592 | $729,817,175 | +$2,899,583 |
| MEGs Escalated (>2% threshold) | 0 | 2 | +2 |
| MEGs Monitored (>1% threshold) | 0 | 3 | +3 |
| MEGs Within Threshold | 13 | 8 | -5 |

**Escalated Items:**
- **ABD Child** (Aged, Blind, and Disabled) -- PMPM exceeded budget by $24.46 (+2.29%), driven by increased long-term care and behavioral health claims. Referred to actuarial team.
- **Choices for Care** (Vermont's high-cost Home and Community Based Services waiver program) -- Enrollment exceeded projection by 125 members (+2.72%), generating approximately $1.09M in unbudgeted annual costs. Budget amendment submitted.

---

## Excel Workbook

**File:** `Vermont_Medicaid_PMPM_Reconciliation_SFY2022.xlsx`

| Tab | Contents |
|---|---|
| SFY2022 Budget Reference | Source DVHA data reproduced verbatim |
| Reconciliation Report | Budget vs. actual comparison across all 13 MEGs |
| Findings and Resolution Log | Root cause analysis and resolution status per flagged item |
| Summary Dashboard | Auto-calculated executive summary of reconciliation results |

---

## SQL Implementation

**Database:** `medicaid_pmpm` (PostgreSQL)

> **Prerequisites:** Before running any SQL scripts, create a database called `medicaid_pmpm` in PostgreSQL. In DBeaver, right-click **Databases**, select **Create Database**, name it `medicaid_pmpm`, and click OK.

### Schema

**`budget_reference`** -- Budgeted PMPM and enrollment figures by MEG.

| Column | Type | Description |
|---|---|---|
| meg | TEXT | Member Eligibility Group name |
| avg_monthly_enrollment | INTEGER | Average monthly member count |
| gross_pmpm | NUMERIC | Gross PMPM before premium offsets |
| premium_pmpm | NUMERIC | Premium assistance offset |
| net_pmpm | NUMERIC | Net PMPM used for budget calculation |
| annual_budget_est | NUMERIC | Estimated annual cost (enrollment x net_pmpm x 12) |

**`reconciliation`** -- Budget vs. actual comparison across all 13 MEGs.

| Column | Type | Description |
|---|---|---|
| meg | TEXT | Member Eligibility Group name |
| budget_enrollment | INTEGER | Projected average monthly enrollment |
| actual_enrollment | INTEGER | Actual average monthly enrollment |
| enrollment_variance | INTEGER | Actual minus budget |
| enrollment_variance_pct | NUMERIC | Variance as a decimal (e.g., 0.027 = 2.7%) |
| budget_pmpm | NUMERIC | Budgeted PMPM |
| actual_pmpm | NUMERIC | Actual PMPM |
| pmpm_variance | NUMERIC | Actual minus budget |
| pmpm_variance_pct | NUMERIC | Variance as a decimal |
| budget_ann_cost | NUMERIC | Budget enrollment x budget PMPM x 12 |
| actual_ann_cost | NUMERIC | Actual enrollment x actual PMPM x 12 |
| cost_impact | NUMERIC | Actual minus budget annual cost |

**`findings_log`** -- Analyst findings for all 13 MEGs.

| Column | Type | Description |
|---|---|---|
| meg | TEXT | Member Eligibility Group name |
| variance_type | TEXT | Enrollment, PMPM Cost, or None |
| budget_figure | TEXT | Budget figure (formatted) |
| actual_figure | TEXT | Actual figure (formatted) |
| variance | TEXT | Variance (formatted) |
| variance_pct | TEXT | Variance percent (formatted) |
| finding_root_cause | TEXT | Analyst root cause narrative |
| resolution_status | TEXT | RESOLVED, ESCALATED, or CLOSED |

### How to Run

**Prerequisites:** PostgreSQL installed locally with DBeaver connected to it.

**Step 1 -- Create the database manually:**
In DBeaver, right-click **Databases**, select **Create Database**, name it `medicaid_pmpm`, and click OK.

**Step 2 -- Run the scripts in order:**

1. `sql/00_setup.sql` -- creates all three tables
2. `sql/01_load_data.sql` -- loads all data via INSERT statements
3. `sql/03_summary_view.sql` -- creates the summary view
4. `sql/02_analysis_queries.sql` -- run individual queries as needed

> **Note:** This project uses `INSERT` statements rather than `COPY` to avoid file path dependencies. The load script is fully self-contained.

### Analysis Queries

- Enrollment and PMPM variance flagging with ESCALATE / MONITOR / OK thresholds
- Cost impact ranking by dollar magnitude
- Combined threshold flag across both variance types
- Join to findings log for escalated items with root cause narrative
- Portfolio-level totals and PMPM tier classification by MEG

---

## Data Source

Vermont Department of Vermont Health Access (DVHA) -- SFY2022 Annual PMPM Legislative Report, September 15, 2022. Submitted by Andrea De La Bruere, Commissioner. Prepared by Patrick Rooney, Financial Director IV.

---

## Author

Graham Pinti -- UVM Economics BA | Data Analytics Portfolio Project
