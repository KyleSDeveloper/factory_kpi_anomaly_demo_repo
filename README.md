# Factory KPI & Anomaly Demo
Synthetic factory telemetry → OEE, downtime Pareto, utilization, and simple anomaly flags. Built for **Operations/BI Analyst** applications.

## Contents
- `data/telemetry.csv` — 10 machines × 24h at 1-min intervals
- `sql/queries.sql` — utilization by hour, downtime Pareto, simplified daily **OEE**
- `scripts/generate_charts.py` — regenerates charts in `images/`
- `images/` — example charts

## Quickstart
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python scripts/generate_charts.py
```

![CI](https://github.com/KyleSDeveloper/factory_kpi_anomaly_demo_repo/actions/workflows/charts.yml/badge.svg)
