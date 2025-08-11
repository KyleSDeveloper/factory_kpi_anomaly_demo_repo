-- Utilization by hour
WITH base AS (
  SELECT DATE_TRUNC('hour', timestamp) AS hour, machine_id,
         CASE WHEN state='RUN' THEN 1 ELSE 0 END AS run_min
  FROM telemetry
)
SELECT hour, machine_id, SUM(run_min) AS run_minutes, COUNT(*) AS total_minutes,
       ROUND(100.0 * SUM(run_min) / COUNT(*), 2) AS utilization_pct
FROM base
GROUP BY hour, machine_id
ORDER BY hour, machine_id;

-- Downtime Pareto
SELECT downtime_reason, COUNT(*) AS minutes
FROM telemetry
WHERE state='DOWN' AND downtime_reason IS NOT NULL
GROUP BY downtime_reason
ORDER BY minutes DESC;

-- Simplified daily OEE
WITH mins AS (
  SELECT DATE(timestamp) AS day, machine_id,
         SUM(CASE WHEN state='RUN' THEN 1 ELSE 0 END) AS run_minutes,
         COUNT(*) AS total_minutes
  FROM telemetry
  GROUP BY 1,2
),
prod AS (
  SELECT DATE(timestamp) AS day, machine_id,
         SUM(units) AS units_produced,
         SUM(good_units) AS good_units
  FROM telemetry
  GROUP BY 1,2
)
SELECT m.day, m.machine_id,
       m.run_minutes, m.total_minutes,
       p.units_produced, p.good_units
FROM mins m
LEFT JOIN prod p ON p.day=m.day AND p.machine_id=m.machine_id
ORDER BY m.day, m.machine_id;
