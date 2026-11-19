import csv
import random
from pathlib import Path
from datetime import date, timedelta

random.seed(42)

ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data" / "raw"
DATA_DIR.mkdir(parents=True, exist_ok=True)

REPORT_DATE = date(2026, 11, 18)
START_DATE = date(2024, 11, 19)

ASSET_TYPES = {
    "Escalator": ["Motor failure", "Step wear", "Sensor fault"],
    "Lift": ["Door fault", "Electrical failure", "Motor failure"],
    "Ticket Machine": ["Payment fault", "Printer fault", "Screen fault"],
    "Ticket Gate": ["Barrier fault", "Card reader fault", "Sensor fault"],
    "CCTV": ["Connectivity fault", "Camera fault", "Power failure"],
    "Platform Equipment": ["Electrical fault", "Component wear"]
}

LOCATIONS = [
    f"Station {letter}" for letter in "ABCDEFGHIJ"
]


def random_date(start, end):
    return start + timedelta(
        days=random.randint(0, (end - start).days)
    )


def write_csv(filename, records):
    path = DATA_DIR / filename

    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file, fieldnames=list(records[0].keys())
        )
        writer.writeheader()
        writer.writerows(records)

    print(f"Created {filename}: {len(records)} records")


# Dataset 1: Asset register
assets = []

for i in range(1, 501):
    assets.append({
        "asset_id": f"A{i:04d}",
        "asset_type": random.choice(list(ASSET_TYPES)),
        "location": random.choice(LOCATIONS),
        "installation_date": random_date(
            date(2010, 1, 1), date(2024, 11, 18)
        ),
        "criticality": random.choice(["High", "Medium", "Low"]),
        "operational_status": random.choices(
            ["Operational", "Out of Service", "Under Maintenance"],
            weights=[90, 4, 6]
        )[0]
    })


# Dataset 2: Maintenance records
maintenance = []

for i in range(1, 5001):
    asset = random.choice(assets)

    maintenance_type = random.choices(
        ["Preventive", "Corrective"],
        weights=[65, 35]
    )[0]

    corrective = maintenance_type == "Corrective"

    downtime = round(
        random.uniform(2, 48) if corrective
        else random.uniform(0.5, 6), 2
    )

    cost = round(
        random.uniform(150, 5000) if corrective
        else random.uniform(50, 800), 2
    )

    maintenance.append({
        "maintenance_id": f"M{i:05d}",
        "asset_id": asset["asset_id"],
        "maintenance_date": random_date(START_DATE, REPORT_DATE),
        "maintenance_type": maintenance_type,
        "fault_category": random.choice(
            ASSET_TYPES[asset["asset_type"]]
        ) if corrective else "Scheduled Servicing",
        "downtime_hours": downtime,
        "maintenance_cost_gbp": cost,
        "status": "Completed"
    })


# Dataset 3: Inspection records
inspections = []

# Ensure every asset has at least one inspection.
inspection_assets = assets * 4
random.shuffle(inspection_assets)

for i, asset in enumerate(inspection_assets, start=1):
    inspection_date = random_date(START_DATE, REPORT_DATE)

    outcome = random.choices(
        ["Pass", "Advisory", "Fail"],
        weights=[80, 15, 5]
    )[0]

    interval = {"High": 90, "Medium": 180, "Low": 365}

    inspections.append({
        "inspection_id": f"I{i:05d}",
        "asset_id": asset["asset_id"],
        "inspection_date": inspection_date,
        "inspection_outcome": outcome,
        "next_due_date": inspection_date + timedelta(
            days=interval[asset["criticality"]]
        )
    })


write_csv("assets.csv", assets)
write_csv("maintenance.csv", maintenance)
write_csv("inspections.csv", inspections)

print("\nSynthetic transport datasets generated successfully.")
