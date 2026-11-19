WITH latest_inspections AS (
    SELECT
        asset_id,
        inspection_date,
        inspection_outcome,
        next_due_date,
        ROW_NUMBER() OVER (
            PARTITION BY asset_id
            ORDER BY inspection_date DESC,
                     inspection_id DESC
        ) AS rn
    FROM inspections
)

SELECT
    a.asset_type,
    COUNT(*) AS total_assets,
    COUNT_IF(
        i.next_due_date < DATE '2026-11-18'
    ) AS overdue_inspections,
    COUNT_IF(
        i.inspection_outcome = 'Fail'
    ) AS failed_latest_inspections,
    ROUND(
        100.0 * COUNT_IF(
            i.next_due_date >= DATE '2026-11-18'
        ) / COUNT(*), 2
    ) AS inspection_schedule_compliance_pct
FROM assets a
JOIN latest_inspections i
    ON a.asset_id = i.asset_id
WHERE i.rn = 1
GROUP BY a.asset_type
ORDER BY inspection_schedule_compliance_pct ASC;