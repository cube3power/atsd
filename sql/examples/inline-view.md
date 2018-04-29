# Inline View

Inline view is a subquery specified in the `FROM` clause instead of the actual table.

## Query

Using Inline view, identify the maximum value in each hour and then calculate the average hourly maximum for each day of the week.

```sql
SELECT datetime, AVG(value) AS "daily_average"
  FROM -- actual table replaced with subquery
  (
    SELECT datetime, MAX(value) AS "value"
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
GROUP BY PERIOD(1 DAY)
```

### Results

```ls
| datetime            | daily_average |
|---------------------|---------------|
| 2017-08-14 00:00:00 | 96.1          |
| 2017-08-15 00:00:00 | 96.6          |
| 2017-08-16 00:00:00 | 98.8          |
| 2017-08-17 00:00:00 | 95.4          |
| 2017-08-18 00:00:00 | 98.3          |
| 2017-08-19 00:00:00 | 96.1          |
| 2017-08-20 00:00:00 | 93.8          |
```

## Query

This query is processed in three stages using nested inline views:

1. Stage 1. Calculate the maximum value in each hour.
2. Stage 2. Calculate the average hourly maximum in each day.
3. Stage 3. Calculate the maximum for all daily averages.

```sql
SELECT MAX(value) FROM (                        -- Stage 3
  SELECT datetime, AVG(value) AS "value" FROM ( -- Stage 2
    SELECT datetime, MAX(value) AS "value"      -- Stage 1
      FROM "mpstat.cpu_busy" WHERE datetime >= CURRENT_WEEK
    GROUP BY PERIOD(1 HOUR)
  )
  GROUP BY PERIOD(1 DAY)
)
```

### Results

Stage 1 results:

```ls
| datetime             | value |
|----------------------|-------|
| 2018-03-05 00:00:00  | 100.0 |
| 2018-03-05 01:00:00  | 92.1  |
| 2018-03-05 02:00:00  | 81.8  |
| 2018-03-05 03:00:00  | 100.0 |
| 2018-03-05 04:00:00  | 90.8  |
| 2018-03-05 05:00:00  | 79.2  |
...
```

Stage 2 results:

```ls
| datetime             | value |
|----------------------|-------|
| 2018-03-05 00:00:00  | 92.4  |
| 2018-03-06 00:00:00  | 87.1  |
```

Stage 3 results:

```ls
| max(value) |
|------------|
| 92.4       |
```

## Query

Group results by a subset of series tags and regularize the series in the subquery, then apply aggregation functions to the subquery results in the containing query.

```sql
SELECT datetime, tags.application, tags.transaction,
  sum(value)/count(value) as daily_good_pct
FROM (
    SELECT datetime, tags.application, tags.transaction,
      CASE WHEN sum(value) >= 0.3 THEN 1 ELSE 0 END AS "value"
    FROM "good_requests"
    WHERE tags.application = 'SSO'
      AND tags.transaction = 'authenticate'
      AND datetime >= '2017-03-15T00:00:00Z' AND datetime < '2017-03-15T03:00:00Z'
      WITH INTERPOLATE (5 MINUTE)
      GROUP BY datetime, tags.application, tags.transaction
)
GROUP BY tags.application, tags.transaction, PERIOD(1 hour)
```

### Results

```ls
| datetime            | tags.application | tags.transaction | hourly_good_pct |
|---------------------|------------------|------------------|-----------------|
| 2017-03-15 00:00:00 | SSO              | authenticate     | 1.00            |
| 2017-03-15 01:00:00 | SSO              | authenticate     | 0.75            |
| 2017-03-15 02:00:00 | SSO              | authenticate     | 0.83            |
```

## Query



```sql
SELECT app,
  SUM(mem_val) AS "apps.usage_memory",
  SUM(rss_val) AS "apps.usage_memory_rss",
  SUM(cpup_val) AS "apps.usage_cpu",
  COUNT(mem_val) AS "apps.active_containers"
  FROM (
    SELECT mem.entity.tags."env.marathon_app_id" AS app,
          AVG(mem.value)/(1024*1024) AS mem_val,
          AVG(rss.value)/(1024*1024) AS rss_val,
        AVG(cpup.value) AS cpup_val
      FROM "docker.memory.usage" AS mem
          OUTER JOIN "docker.memory.rss" as rss
          OUTER JOIN "docker.cpu.avg.usage.total.percent" AS cpup
      WHERE mem.entity.tags."env.marathon_app_id" IS NOT NULL
          AND datetime BETWEEN NOW - 5*minute AND NOW
    GROUP BY mem.entity
) GROUP BY app
```

### Results

Subquery results:

```ls
| app              | mem_val  | rss_val  | cpup_val |
|------------------|----------|----------|----------|
| /busybox-copies  | 1.4      | 0.0      | 0.0      |
| /busybox-copies  | 1.4      | 0.0      | 0.0      |
| /busybox-copies  | 1.5      | 0.0      | 0.0      |
| /busybox-copies  | 1.5      | 0.0      | 0.0      |
| /nginx           | 8.3      | 1.3      | 0.0      |
```

Parent query results:

```ls
| app              | apps.usage_memory  | apps.usage_memory_rss  | apps.usage_cpu  | apps.active_containers |
|------------------|--------------------|------------------------|-----------------|------------------------|
| /busybox-copies  | 5.8                | 0.2                    | 0.0             | 4                      |
| /nginx           | 8.3                | 1.3                    | 0.0             | 1                      |
```
