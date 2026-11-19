SELECT
    DATE_TRUNC('month', maintenance_date) AS reporting_month,
    maintenance_type,
    COUNT(*) AS maintenance_jobs,
    SUM(maintenance_cost_gbp) AS total_cost_gbp,
    ROUND(SUM(downtime_hours), 2) AS total_downtime,
    ROUND(AVG(downtime_hours), 2) AS average_downtime
FROM maintenance
GROUP BY
    DATE_TRUNC('month', maintenance_date),
    maintenance_type
ORDER BY
    reporting_month,
    maintenance_type;