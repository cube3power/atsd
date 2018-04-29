# Computed Columns

Computed columns can be created by applying functions and arithmetic expression to existing columns.

The computed columns can be used both in the `SELECT` expression as well as in `WHERE`, `HAVING`, and `ORDER BY` clauses.

## Query with Join

```sql
SELECT t1.datetime AS "datetime", t1.entity AS "entity", t1.value, t2.value, t1.value + t2.value AS total_cpu
    FROM "mpstat.cpu_system" t1
    JOIN "mpstat.cpu_user" t2
WHERE t1.datetime > now - 1*MINUTE AND t2.datetime > now - 1*MINUTE
```

### Results

```ls
| datetime                 | entity       | t1.value | t2.value | total_cpu |
|--------------------------|--------------|----------|----------|-----------|
| 2016-08-15T07:53:01.000Z | nurswgvml006 | 1.0      | 1.0      | 2.0       |
| 2016-08-15T07:53:17.000Z | nurswgvml006 | 1.0      | 2.0      | 3.0       |
| 2016-08-15T07:53:33.000Z | nurswgvml006 | 0.0      | 4.0      | 4.0       |
| 2016-08-15T07:53:49.000Z | nurswgvml006 | 2.0      | 4.0      | 6.0       |
| 2016-08-15T07:52:59.000Z | nurswgvml007 | 1.0      | 2.0      | 3.0       |
```

## Query with `JOIN` and Functions

```sql
SELECT t1.datetime, t1.entity, max(t1.value), max(t2.value), max(t1.value) + max(t2.value), max(t1.value + t2.value) AS max_total_cpu
  FROM "mpstat.cpu_system" t1
  JOIN "mpstat.cpu_user" t2
WHERE t1.datetime > now - 1*MINUTE
GROUP BY t1.entity, t1.datetime
```

### Results

```ls
| datetime                 | entity       | max(t1.value) | max(t2.value) | max(t1.value)+max(t2.value) | max_total_cpu |
|--------------------------|--------------|---------------|---------------|-----------------------------|---------------|
| 2016-07-15T14:41:58.000Z | nurswgvml007 | 2.0           | 24.8          | 26.8                        | 25.1          |
```

## Query with Computed Columns in `ORDER BY` Clause

```sql
SELECT entity, tags.file_system, tags.mount_point, min(value), max(value), max(value) - min(value) AS range
 FROM "df.disk_used"
WHERE datetime >= now - 1 * HOUR
 GROUP BY entity, tags
 ORDER BY max(value) - min(value) DESC
```

### Results

```ls
| entity       | tags.file_system                    | tags.mount_point | min(value) | max(value) | range     |
|--------------|-------------------------------------|------------------|------------|------------|-----------|
| nurswgvml010 | /dev/sdb1                           | /app             | 30131084.0 | 33794988.0 | 3663904.0 |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive | 54354244.0 | 54536264.0 | 182020.0  |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                | 9158952.0  | 9211892.0  | 52940.0   |
| nurswgvml011 | /dev/sda1                           | /                | 6818064.0  | 6827156.0  | 9092.0    |
| nurswgvml009 | /dev/sdb1                           | /opt             | 30847072.0 | 30852760.0 | 5688.0    |
```

## Query with `HAVING` Clause

```sql
SELECT entity, min(value), max(value), max(value) - min(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= now - 1 * minute
  GROUP BY entity
HAVING max(value) - min(value) > 10
  ORDER BY max(value) - min(value) DESC
```

### Results

```ls
| entity       | min(value) | max(value) | max(value)-min(value) |
|--------------|------------|------------|-----------------------|
| nurswgvml010 | 0.2        | 25.1       | 24.9                  |
| nurswgvml502 | 0.5        | 15.5       | 15.0                  |
```
