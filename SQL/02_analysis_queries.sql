-- ============================================================
-- Vermont Medicaid PMPM Reconciliation SFY2022
-- Analysis Queries
-- ============================================================


-- ============================================================
-- Q1: Enrollment variance — flag MEGs outside ±2% threshold
-- ============================================================
SELECT
    meg,
    budget_enrollment,
    actual_enrollment,
    enrollment_variance,
    ROUND(enrollment_variance_pct * 100, 2)  AS enrollment_variance_pct,
    CASE
        WHEN ABS(enrollment_variance_pct) > 0.02 THEN 'ESCALATE'
        WHEN ABS(enrollment_variance_pct) > 0.01 THEN 'MONITOR'
        ELSE 'WITHIN THRESHOLD'
    END AS enrollment_flag
FROM reconciliation
ORDER BY ABS(enrollment_variance_pct) DESC;


-- ============================================================
-- Q2: PMPM variance — flag MEGs outside ±2% threshold
-- ============================================================
SELECT
    meg,
    budget_pmpm,
    actual_pmpm,
    pmpm_variance,
    ROUND(pmpm_variance_pct * 100, 2) AS pmpm_variance_pct,
    CASE
        WHEN ABS(pmpm_variance_pct) > 0.02 THEN 'ESCALATE'
        WHEN ABS(pmpm_variance_pct) > 0.01 THEN 'MONITOR'
        ELSE 'WITHIN THRESHOLD'
    END AS pmpm_flag
FROM reconciliation
ORDER BY ABS(pmpm_variance_pct) DESC;


-- ============================================================
-- Q3: Cost impact ranking — largest dollar deviations
-- ============================================================
SELECT
    meg,
    budget_ann_cost,
    ROUND(actual_ann_cost, 2) as actual_ann_cost,
    ROUND(cost_impact, 2) as cost_impact,
    ROUND((cost_impact / NULLIF(budget_ann_cost, 0)) * 100, 2) AS cost_impact_pct,
    CASE
        WHEN cost_impact > 0 THEN 'UNFAVORABLE'
        WHEN cost_impact < 0 THEN 'FAVORABLE'
        ELSE 'NEUTRAL'
    END AS direction
FROM reconciliation
ORDER BY ABS(cost_impact) DESC;


-- ============================================================
-- Q4: Combined threshold flag — any variance type that escalates
-- ============================================================
SELECT
    meg,
    ROUND(enrollment_variance_pct * 100, 2)  AS enroll_var_pct,
    ROUND(pmpm_variance_pct * 100, 2)         AS pmpm_var_pct,
    ROUND(cost_impact, 2) as  cost_impact,
    CASE
        WHEN ABS(enrollment_variance_pct) > 0.02
          OR ABS(pmpm_variance_pct)        > 0.02 THEN 'ESCALATE'
        WHEN ABS(enrollment_variance_pct) > 0.01
          OR ABS(pmpm_variance_pct)        > 0.01 THEN 'MONITOR'
        ELSE 'OK'
    END AS overall_flag
FROM reconciliation
ORDER BY overall_flag DESC, ABS(cost_impact) DESC;


-- ============================================================
-- Q5: Join reconciliation to findings_log for escalated items
-- ============================================================
SELECT
    r.meg,
    r.enrollment_variance,
    ROUND(r.enrollment_variance_pct * 100, 2) AS enroll_pct,
    r.pmpm_variance,
    ROUND(r.pmpm_variance_pct * 100, 2)        AS pmpm_pct,
    r.cost_impact,
    f.variance_type,
    f.finding_root_cause,
    f.resolution_status
FROM reconciliation r
LEFT JOIN findings_log f
    ON r.meg = f.meg
WHERE
    ABS(r.enrollment_variance_pct) > 0.02
    OR ABS(r.pmpm_variance_pct)    > 0.02
ORDER BY ABS(r.cost_impact) DESC;


-- ============================================================
-- Q6: Portfolio-level totals — budget vs actual
-- ============================================================
SELECT
    SUM(budget_enrollment)                         AS total_budget_enrollment,
    SUM(actual_enrollment)                         AS total_actual_enrollment,
    SUM(actual_enrollment) - SUM(budget_enrollment) AS total_enrollment_variance,
    ROUND(SUM(budget_ann_cost) / 1e6, 2)           AS total_budget_cost_M,
    ROUND(SUM(actual_ann_cost) / 1e6, 2)           AS total_actual_cost_M,
    ROUND(SUM(cost_impact) / 1e6, 2)               AS total_cost_impact_M
FROM reconciliation;


-- ============================================================
-- Q7: Budget reference — PMPM tier classification
-- ============================================================
SELECT
    meg,
    avg_monthly_enrollment,
    net_pmpm,
    annual_budget_est,
    CASE
        WHEN net_pmpm >= 500  THEN 'HIGH COST (≥$500 PMPM)'
        WHEN net_pmpm >= 100  THEN 'MODERATE ($100–$499 PMPM)'
        ELSE                       'LOW COST (<$100 PMPM)'
    END AS pmpm_tier
FROM budget_reference
ORDER BY net_pmpm DESC;
