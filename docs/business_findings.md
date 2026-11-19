# Transport Asset Performance — Business Findings

## 1. Executive Summary

This project analyses the maintenance expenditure, operational availability and inspection schedule compliance of 500 fictional transport assets across ten stations.

The analysis combines Amazon Athena SQL, Excel and Microsoft Power BI to support evidence-based asset management decisions.

Reporting date: 18 November 2026.

## 2. Key Performance Indicators

| Metric | Result |
|---|---:|
| Total assets | 500 |
| Maintenance activities | 5,000 |
| Inspection records | 2,000 |
| Total maintenance expenditure | £5,788,267.13 |
| Recorded downtime | 53,412.15 hours |
| Operational assets | 453 |
| Non-operational assets | 47 |
| Operational availability | 90.60% |
| Assets with overdue inspections | 145 |
| Inspection schedule compliance | 71.00% |

## 3. Key Findings and Recommendations

### Finding 1 — Corrective maintenance dominates expenditure

Corrective maintenance represents approximately 34% of maintenance activities but accounts for 76% of total expenditure and 80% of recorded downtime.

Average downtime per corrective maintenance activity is 24.93 hours, compared with 3.22 hours for preventive maintenance.

**Recommendation:** Investigate opportunities to optimise preventive maintenance schedules and reduce avoidable corrective maintenance.

### Finding 2 — Escalators generate the highest expenditure

Escalator maintenance accounts for approximately £1.17 million in expenditure. However, escalators also represent the largest asset category.

Lifts have the highest average downtime per maintenance activity, at 11.62 hours.

**Recommendation:** Investigate recurring faults, asset age, criticality and maintenance cost per asset before prioritising equipment investment.

### Finding 3 — Station-level expenditure varies

Station F records the highest maintenance cost per asset at £12,482.32, compared with £10,202.11 at Station I.

**Recommendation:** Investigate differences in asset composition, maintenance frequency and equipment age across stations.

### Finding 4 — Operational availability requires monitoring

453 of the 500 assets are operational, producing a snapshot availability rate of 90.60%.

**Recommendation:** Prioritise investigation of non-operational critical assets and monitor recovery times.

### Finding 5 — Overdue inspections require attention

145 assets have overdue inspections, resulting in inspection schedule compliance of 71%.

**Recommendation:** Establish a prioritised inspection backlog based on asset criticality and introduce automated reminders for upcoming inspection deadlines.

## 4. Data Quality and Validation

- Python validation passed all 13 data quality checks.
- Athena queries confirmed the expected 7,500 source records.
- Excel PivotTable results were compared with Athena SQL calculations.
- Power BI headline KPIs were independently cross-validated against Athena.
- Interactive slicers support station-level and asset-category analysis.

## 5. Limitations

- All datasets are synthetic and do not represent any real transport organisation.
- Maintenance cost and downtime patterns were intentionally introduced during data generation.
- Findings demonstrate analytical techniques rather than establish real-world causal relationships.
- Operational availability represents a snapshot, not historical uptime.
- Inspection schedule compliance does not establish equipment safety or regulatory compliance.
- The first and last months of the maintenance reporting period are incomplete.

## 6. Conclusion

The analytics platform demonstrates how cloud-based data storage, SQL analysis and interactive business intelligence can support maintenance planning, expenditure monitoring and asset performance assessment.