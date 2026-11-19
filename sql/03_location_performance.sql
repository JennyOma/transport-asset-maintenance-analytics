SELECT
    a.location,
    COUNT(DISTINCT a.asset_id) AS total_assets,
    COUNT(m.maintenance_id) AS maintenance_jobs,
    SUM(m.maintenance_cost_gbp) AS total_cost_gbp,
    ROUND(
        SUM(m.maintenance_cost_gbp) /
        COUNT(DISTINCT a.asset_id), 2
    ) AS cost_per_asset,
    ROUND(SUM(m.downtime_hours), 2) AS total_downtime
FROM assets a
LEFT JOIN maintenance m
    ON a.asset_id = m.asset_id
GROUP BY a.location
ORDER BY cost_per_asset DESC;