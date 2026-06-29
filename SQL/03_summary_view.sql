-- ============================================================
-- Vermont Medicaid PMPM Reconciliation SFY2022
-- Summary View
-- ============================================================

-- Drop and recreate for idempotent re-runs
DROP VIEW IF EXISTS vw_reconciliation_summary;

CREATE VIEW vw_reconciliation_summary AS
SELECT
    r.meg,

    -- Enrollment
    r.budget_enrollment,
    r.actual_enrollment,
    r.enrollment_variance,
    ROUND(r.enrollment_variance_pct * 100, 2)  AS enrollment_variance_pct,

    -- PMPM
    r.budget_pmpm,
    r.actual_pmpm,
    r.pmpm_variance,
    ROUND(r.pmpm_variance_pct * 100, 2)         AS pmpm_variance_pct,

    -- Cost
    ROUND(r.budget_ann_cost / 1e6, 4)            AS budget_ann_cost_M,
    ROUND(r.actual_ann_cost  / 1e6, 4)           AS actual_ann_cost_M,
    ROUND(r.cost_impact      / 1e6, 4)           AS cost_impact_M,

    -- PMPM tier from budget_reference
    b.net_pmpm,
    CASE
        WHEN b.net_pmpm >= 500 THEN 'HIGH COST'
        WHEN b.net_pmpm >= 100 THEN 'MODERATE'
        ELSE 'LOW COST'
    END AS pmpm_tier,

    -- Threshold flags
    CASE
        WHEN ABS(r.enrollment_variance_pct) > 0.02 THEN 'ESCALATE'
        WHEN ABS(r.enrollment_variance_pct) > 0.01 THEN 'MONITOR'
        ELSE 'OK'
    END AS enrollment_flag,

    CASE
        WHEN ABS(r.pmpm_variance_pct) > 0.02 THEN 'ESCALATE'
        WHEN ABS(r.pmpm_variance_pct) > 0.01 THEN 'MONITOR'
        ELSE 'OK'
    END AS pmpm_flag,

    CASE
        WHEN ABS(r.enrollment_variance_pct) > 0.02
          OR ABS(r.pmpm_variance_pct)        > 0.02 THEN 'ESCALATE'
        WHEN ABS(r.enrollment_variance_pct) > 0.01
          OR ABS(r.pmpm_variance_pct)        > 0.01 THEN 'MONITOR'
        ELSE 'OK'
    END AS overall_flag,

    -- Findings linkage
    f.enrollment_finding,
    f.pmpm_finding,
    f.enrollment_resolution,
    f.pmpm_resolution

FROM reconciliation r
LEFT JOIN budget_reference b ON r.meg = b.meg
LEFT JOIN (
	select
		meg,
		MAX(case when variance_type = 'Enrollment' then finding_root_cause end) as enrollment_finding,
		MAX(case when variance_type = 'PMPM Cost' then finding_root_cause end) as pmpm_finding,
		MAX(case when variance_type = 'Enrollment' then resolution_status end) as enrollment_resolution,
		MAX(case when variance_type = 'PMPM Cost' then resolution_status end) as pmpm_resolution	
	from findings_log     
	group by meg
) f ON r.meg = f.meg;


-- ── Preview the view ──────────────────────────────────────────
SELECT * FROM vw_reconciliation_summary ORDER BY overall_flag DESC, ABS(cost_impact_M) DESC;
