SELECT
    asset_type,
    COUNT(*) AS total_assets,
    COUNT_IF(operational_status = 'Operational')
        AS operational_assets,
    COUNT_IF(operational_status = 'Out of Service')
        AS out_of_service,
    COUNT_IF(operational_status = 'Under Maintenance')
        AS under_maintenance,
    ROUND(
        100.0 * COUNT_IF(operational_status = 'Operational')
        / COUNT(*), 2
    ) AS availability_percentage
FROM assets
GROUP BY asset_type
ORDER BY availability_percentage ASC;