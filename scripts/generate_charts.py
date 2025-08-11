import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt

root = Path(__file__).resolve().parents[1]
df = pd.read_csv(root / 'data' / 'telemetry.csv', parse_dates=['timestamp'])

agg = df.groupby('machine_id').agg(
    run_mins=('state', lambda s: (s=='RUN').sum()),
    total_mins=('state','count'),
    units=('units','sum'),
    good=('good_units','sum')
).reset_index()

availability = agg['run_mins'] / agg['total_mins']
performance = (agg['units'] * 5.5 / 60.0) / (agg['run_mins'] / 60.0).replace(0, float('nan'))
quality = agg['good'] / agg['units'].replace(0, float('nan'))
oee = (availability * performance * quality).fillna(0)

plt.figure(figsize=(8,4))
plt.bar(agg['machine_id'], oee)
plt.title('OEE by Machine (Demo)'); plt.xlabel('Machine'); plt.ylabel('OEE')
plt.tight_layout(); plt.savefig(root / 'images' / 'oee_by_machine.png', dpi=150); plt.close()

dt = df[df['state']=='DOWN'].groupby('downtime_reason').size().sort_values(ascending=False)
plt.figure(figsize=(8,4))
dt.plot(kind='bar')
plt.title('Downtime Pareto (minutes)'); plt.xlabel('Reason'); plt.ylabel('Minutes')
plt.tight_layout(); plt.savefig(root / 'images' / 'downtime_pareto.png', dpi=150); plt.close()

print('Charts saved to images/.')
