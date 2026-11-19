WITH latest_inspections AS (
    SELECT
        asset_id,
        next_due_date,
        ROW_NUMBER() OVER (
            PARTITION BY asset_id
            ORDER BY inspection_date DESC,
                     inspection_id DESC
        ) AS rn
    FROM inspections
)

SELECT
    (SELECT COUNT(*) FROM assets)
        AS total_assets,

    (SELECT COUNT(*) FROM maintenance)
        AS maintenance_jobs,

    (SELECT SUM(maintenance_cost_gbp) FROM maintenance)
        AS total_cost_gbp,

    (SELECT COUNT_IF(operational_status = 'Operational')
     FROM assets)
        AS operational_assets,

    (SELECT ROUND(
        100.0 * COUNT_IF(operational_status = 'Operational')
        / COUNT(*), 2)
     FROM assets)
        AS availability_pct,

    (SELECT COUNT_IF(next_due_date < DATE '2026-11-18')
     FROM latest_inspections
     WHERE rn = 1)
        AS overdue_inspections,

    (SELECT ROUND(
        100.0 * COUNT_IF(next_due_date >= DATE '2026-11-18')
        / COUNT(*), 2)
     FROM latest_inspections
     WHERE rn = 1)
        AS compliance_pct;