SELECT
    maintenance_type,
    COUNT(*) AS maintenance_count,
    SUM(maintenance_cost_gbp) AS total_cost_gbp,
    ROUND(SUM(downtime_hours), 2) AS total_downtime,
    ROUND(AVG(downtime_hours), 2) AS average_downtime
FROM maintenance
GROUP BY maintenance_type
ORDER BY total_cost_gbp DESC;