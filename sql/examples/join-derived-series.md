# JOIN - Derived Series

Other than collating results from multiple underlying series, `JOIN` queries can produce derived (computed) series.

## Inner JOIN

If the series have the same timestamps, inner `JOIN` is sufficient.

### Query

```sql
SELECT tot.entity, tot.datetime,
  tot.value/1024 "total",
  fre.value/1024 "free",
  (tot.value - fre.value)/1024 "used",
  (1-fre.value/tot.value)*100 "used_%"
FROM "meminfo.memtotal" AS tot
  JOIN "meminfo.memfree" AS fre
WHERE tot.datetime BETWEEN '2017-05-30T00:00:00Z' AND '2017-05-30T00:01:00Z'
  AND tot.entity = 'nurswgvml007'
```

### Results

```ls
| tot.entity   | tot.datetime         | total  | free  | used   | used_% |
|--------------|----------------------|--------|-------|--------|--------|
| nurswgvml007 | 2017-05-30T00:00:02Z | 1877.1 | 399.9 | 1477.2 | 78.7   |
| nurswgvml007 | 2017-05-30T00:00:17Z | 1877.1 | 398.7 | 1478.4 | 78.8   |
| nurswgvml007 | 2017-05-30T00:00:32Z | 1877.1 | 398.2 | 1478.9 | 78.8   |
| nurswgvml007 | 2017-05-30T00:00:47Z | 1877.1 | 397.5 | 1479.6 | 78.8   |
```

## OUTER JOIN

If the series have different timestamps, `OUTER JOIN` with interpolation or aggregation is necessary.

### DETAIL Interpolation Query

```sql
SELECT datetime, tot.entity,
  tot.value/1024 AS mem_total,
  fre.value/1024 AS mem_free,
  (tot.value - fre.value)/1024 AS mem_used,
  (1-fre.value/tot.value)*100 AS "mem_used_%",
  cpu.value AS "cpu_%",
  CASE WHEN (1-fre.value/tot.value)*100 > 80 AND cpu.value > 80 THEN 'Over-utilized' ELSE 'OK' END AS status
FROM "meminfo.memtotal" AS tot
  OUTER JOIN "meminfo.memfree" AS fre
  OUTER JOIN "mpstat.cpu_busy" AS cpu
WHERE tot.datetime BETWEEN '2017-05-30T00:06:00Z' AND '2017-05-30T00:06:30Z'
  AND tot.entity = 'nurswgvml006'
  WITH INTERPOLATE(DETAIL, LINEAR, OUTER)
```

### Results

```ls
| datetime             | tot.entity   | mem_total | mem_free | mem_used | mem_used_% | cpu_% | status        |
|----------------------|--------------|-----------|----------|----------|------------|-------|---------------|
| 2017-05-30T00:06:06Z | nurswgvml006 | 1877.8    | 72.8     | 1805.0   | 96.1       | 100.0 | Over-utilized |
| 2017-05-30T00:06:14Z | nurswgvml006 | 1877.8    | 74.4     | 1803.4   | 96.0       | 54.3  | OK            |
| 2017-05-30T00:06:23Z | nurswgvml006 | 1877.8    | 73.7     | 1804.1   | 96.1       | 3.0   | OK            |
| 2017-05-30T00:06:29Z | nurswgvml006 | 1877.8    | 73.2     | 1804.6   | 96.1       | 39.4  | OK            |
```

### Regular Interpolation Query

```sql
SELECT datetime, tot.entity,
  tot.value/1024 AS mem_total,
  fre.value/1024 AS mem_free,
  (tot.value - fre.value)/1024 AS mem_used,
  (1-fre.value/tot.value)*100 AS "mem_used_%",
  cpu.value AS "cpu_%",
  CASE WHEN (1-fre.value/tot.value)*100 > 80 AND cpu.value > 80 THEN 'Over-utilized' ELSE 'OK' END AS status
FROM "meminfo.memtotal" AS tot
  OUTER JOIN "meminfo.memfree" AS fre
  OUTER JOIN "mpstat.cpu_busy" AS cpu
WHERE tot.datetime BETWEEN '2017-05-30T00:06:00Z' AND '2017-05-30T00:06:30Z'
  AND tot.entity = 'nurswgvml006'
  WITH INTERPOLATE(5 SECOND, LINEAR, OUTER)
```

### Results

```ls
| datetime             | tot.entity   | mem_total | mem_free | mem_used | mem_used_% | cpu_% | status        |
|----------------------|--------------|-----------|----------|----------|------------|-------|---------------|
| 2017-05-30T00:06:00Z | nurswgvml006 | 1877.8    | 71.6     | 1806.2   | 96.2       | 63.6  | OK            |
| 2017-05-30T00:06:05Z | nurswgvml006 | 1877.8    | 72.6     | 1805.2   | 96.1       | 93.9  | Over-utilized |
| 2017-05-30T00:06:10Z | nurswgvml006 | 1877.8    | 73.6     | 1804.2   | 96.1       | 77.2  | OK            |
| 2017-05-30T00:06:15Z | nurswgvml006 | 1877.8    | 74.3     | 1803.5   | 96.0       | 48.6  | OK            |
| 2017-05-30T00:06:20Z | nurswgvml006 | 1877.8    | 73.9     | 1803.9   | 96.1       | 20.1  | OK            |
| 2017-05-30T00:06:25Z | nurswgvml006 | 1877.8    | 73.5     | 1804.3   | 96.1       | 15.1  | OK            |
| 2017-05-30T00:06:30Z | nurswgvml006 | 1877.8    | 72.1     | 1805.6   | 96.2       | 45.4  | OK            |
```

### Aggregation Query

```sql
SELECT datetime, COALESCE(tot.entity, fre.entity, cpu.entity) AS server,
  AVG(tot.value)/1024 AS mem_total,
  AVG(fre.value)/1024 AS mem_free,
  AVG(tot.value - fre.value)/1024 AS mem_used,
  AVG(1-fre.value/tot.value)*100 AS "mem_used_%",
  AVG(cpu.value) AS "cpu_%",
  CASE WHEN AVG(1-fre.value/tot.value)*100 > 80 AND AVG(cpu.value) > 80 THEN 'Over-utilized' ELSE 'OK' END AS status
FROM "memtotal" AS tot
  OUTER JOIN "memfree" AS fre
  OUTER JOIN "cpu_busy" AS cpu
WHERE tot.datetime BETWEEN '2017-05-30T00:06:00Z' AND '2017-05-30T00:07:00Z'
  AND tot.entity = 'nurswgvml006'
  GROUP BY server, PERIOD(15 SECOND)
```

### Results

```ls
| datetime             | server       | mem_total | mem_free | mem_used | mem_used_% | cpu_% | status        |
|----------------------|--------------|-----------|----------|----------|------------|-------|---------------|
| 2017-05-30T00:06:00Z | nurswgvml006 | 1877.8    | 74.4     | 1803.4   | 96.0       | 100.0 | Over-utilized |
| 2017-05-30T00:06:15Z | nurswgvml006 | 1877.8    | 73.2     | 1804.6   | 96.1       | 3.0   | OK            |
| 2017-05-30T00:06:30Z | nurswgvml006 | 1877.8    | 57.3     | 1820.5   | 96.9       | 100.0 | Over-utilized |
| 2017-05-30T00:06:45Z | nurswgvml006 | 1877.8    | 71.5     | 1806.2   | 96.2       | 15.0  | OK            |
```
