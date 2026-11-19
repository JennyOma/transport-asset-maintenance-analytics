SELECT
    a.asset_type,
    COUNT(DISTINCT a.asset_id) AS total_assets,
    COUNT(m.maintenance_id) AS maintenance_jobs,
    SUM(m.maintenance_cost_gbp) AS total_cost_gbp,
    ROUND(SUM(m.downtime_hours), 2) AS total_downtime,
    ROUND(AVG(m.downtime_hours), 2) AS average_downtime
FROM assets a
LEFT JOIN maintenance m
    ON a.asset_id = m.asset_id
GROUP BY a.asset_type
ORDER BY total_cost_gbp DESC;