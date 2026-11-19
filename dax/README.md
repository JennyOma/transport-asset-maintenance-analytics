
# Power BI DAX Measures

This project uses 14 DAX measures to calculate maintenance, asset availability and inspection performance metrics.

The Power BI semantic model contains three tables:
- `assets` — asset dimension
- `maintenance` — maintenance fact table
- `inspections` — inspection fact table

Relationships use `asset_id`, with one-to-many filtering from `assets` to the fact tables.

## Asset measures

### Total Assets

```dax
Total Assets = COUNTROWS(assets)
```

### Operational Assets

```dax
Operational Assets =
CALCULATE(
    [Total Assets],
    assets[operational_status] = "Operational"
)
```

### Non Operational Assets

```dax
Non Operational Assets =
[Total Assets] - [Operational Assets]
```

### Operational Availability %

```dax
Operational Availability % =
DIVIDE(
    [Operational Assets],
    [Total Assets],
    0
)
```

Measures snapshot operational status, not historical uptime.

## Maintenance measures

### Total Maintenance Jobs

```dax
Total Maintenance Jobs = COUNTROWS(maintenance)
```

### Total Maintenance Cost

```dax
Total Maintenance Cost =
SUM(maintenance[maintenance_cost_gbp])
```

### Total Downtime Hours

```dax
Total Downtime Hours =
SUM(maintenance[downtime_hours])
```

### Average Downtime Hours

```dax
Average Downtime Hours =
AVERAGE(maintenance[downtime_hours])
```

### Corrective Maintenance Jobs

```dax
Corrective Maintenance Jobs =
CALCULATE(
    [Total Maintenance Jobs],
    maintenance[maintenance_type] = "Corrective"
)
```

### Cost Per Asset

```dax
Cost Per Asset =
DIVIDE(
    [Total Maintenance Cost],
    [Total Assets],
    0
)
```

## Inspection measures

### Total Inspections

```dax
Total Inspections = COUNTROWS(inspections)
```

### Overdue Inspections

```dax
Overdue Inspections =
SUMX(
    VALUES(assets[asset_id]),
    VAR LatestInspection =
        CALCULATETABLE(
            TOPN(
                1,
                inspections,
                inspections[inspection_date], DESC,
                inspections[inspection_id], DESC
            )
        )
    VAR DueDate =
        MAXX(
            LatestInspection,
            inspections[next_due_date]
        )
    RETURN
        IF(
            NOT ISBLANK(DueDate) &&
            DueDate < DATE(2026, 11, 18),
            1,
            0
        )
)
```

### Assets With Inspections

```dax
Assets With Inspections =
DISTINCTCOUNT(inspections[asset_id])
```

### Inspection Compliance %

```dax
Inspection Compliance % =
DIVIDE(
    [Assets With Inspections] - [Overdue Inspections],
    [Assets With Inspections],
    0
)
```

Inspection compliance is evaluated against the fixed reporting date of 18 November 2026. It measures whether the latest inspection is overdue, not whether the asset is safe to operate.

## Validated KPIs

| Metric | Result |
|---|---:|
| Total assets | 500 |
| Maintenance jobs | 5,000 |
| Total maintenance expenditure | £5,788,267.13 |
| Operational assets | 453 |
| Operational availability | 90.60% |
| Overdue inspections | 145 |
| Inspection schedule compliance | 71.00% |

These results were independently checked against Amazon Athena SQL queries.
