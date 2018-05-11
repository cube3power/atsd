# Aggregate Percentiles

Percentiles for a given entity.

`median(value)` is equivalent to `percentile(50, value)`.

## Query

```sql
SELECT percentile(25, value) AS "p25",
  percentile(50, value) AS "p50",
  median(value),
  percentile(75, value) AS "p75",
  percentile(90, value) AS "p90",
  percentile(95, value) AS "p95",
  percentile(97.5, value) AS "p97.5",
  percentile(99, value) AS "p99",
  percentile(99.5, value) AS "p99.5",
  percentile(99.9, value) AS "p99.9",
  percentile(99.99, value) AS "p99.99"
  FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml007'
 AND datetime >= current_day
```

## Results

```ls
| p25   | p50   | median(value) | p75   | p90    | p95    | p97.5  | p99    | p99.5  | p99.9  | p99.99 |
|-------|-------|---------------|-------|--------|--------|--------|--------|--------|--------|--------|
| 4.040 | 6.060 | 6.060         | 9.380 | 23.064 | 42.404 | 55.299 | 82.163 | 93.837 | 98.997 | 99.010 |
```
