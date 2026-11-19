import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data" / "raw"


def load_csv(filename):
    with (DATA_DIR / filename).open(
        encoding="utf-8", newline=""
    ) as file:
        return list(csv.DictReader(file))


assets = load_csv("assets.csv")
maintenance = load_csv("maintenance.csv")
inspections = load_csv("inspections.csv")

asset_ids = {row["asset_id"] for row in assets}

checks = {
    "500 asset records": len(assets) == 500,
    "5000 maintenance records": len(maintenance) == 5000,
    "2000 inspection records": len(inspections) == 2000,

    "Unique asset IDs":
        len(asset_ids) == len(assets),

    "Unique maintenance IDs":
        len({r["maintenance_id"] for r in maintenance})
        == len(maintenance),

    "Unique inspection IDs":
        len({r["inspection_id"] for r in inspections})
        == len(inspections),

    "Valid maintenance asset references":
        all(r["asset_id"] in asset_ids for r in maintenance),

    "Valid inspection asset references":
        all(r["asset_id"] in asset_ids for r in inspections),

    "No missing values":
        all(
            all(v and v.strip() for v in row.values())
            for row in assets + maintenance + inspections
        ),

    "Non-negative maintenance costs":
        all(float(r["maintenance_cost_gbp"]) >= 0
            for r in maintenance),

    "Non-negative downtime":
        all(float(r["downtime_hours"]) >= 0
            for r in maintenance),

    "Valid inspection due dates":
        all(r["next_due_date"] > r["inspection_date"]
            for r in inspections),

    "Every asset has an inspection":
        asset_ids == {r["asset_id"] for r in inspections}
}

print("\nTRANSPORT DATA QUALITY REPORT")
print("-" * 45)

for name, passed in checks.items():
    print(f"{'PASS' if passed else 'FAIL'} | {name}")

passed_count = sum(checks.values())

print("-" * 45)
print(f"Tests passed: {passed_count}/{len(checks)}")

if not all(checks.values()):
    raise SystemExit("Data validation failed.")

print("Data validation successful.")

