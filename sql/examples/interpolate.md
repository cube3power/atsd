# Interpolate

## No Interpolation

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute)
```

Value for period **2016-06-03T09:30:00.000Z** is missing.

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml007 | 2016-06-03T09:20:00.000Z      | 18           |
| nurswgvml007 | 2016-06-03T09:25:00.000Z      | 8            |
| nurswgvml007 | 2016-06-03T09:35:00.000Z      | 6            |
| nurswgvml007 | 2016-06-03T09:40:00.000Z      | 19           |
| nurswgvml007 | 2016-06-03T09:45:00.000Z      | 19           |
```


## Fill Gaps with Constant Value 0

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute, VALUE 0)
```

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml007 | 2016-06-03T09:20:00.000Z      | 18           |
| nurswgvml007 | 2016-06-03T09:25:00.000Z      | 8            |
| nurswgvml007 | 2016-06-03T09:30:00.000Z      | 0            | + interpolated +
| nurswgvml007 | 2016-06-03T09:35:00.000Z      | 6            |
| nurswgvml007 | 2016-06-03T09:40:00.000Z      | 19           |
| nurswgvml007 | 2016-06-03T09:45:00.000Z      | 19           |
```

## Set to Previous Period Value

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute, PREVIOUS)
```

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml007 | 2016-06-03T09:20:00.000Z      | 18           |
| nurswgvml007 | 2016-06-03T09:25:00.000Z      | 8            |
| nurswgvml007 | 2016-06-03T09:30:00.000Z      | 8            |  + interpolated +
| nurswgvml007 | 2016-06-03T09:35:00.000Z      | 6            |
| nurswgvml007 | 2016-06-03T09:40:00.000Z      | 19           |
| nurswgvml007 | 2016-06-03T09:45:00.000Z      | 19           |
```

## Linear Interpolation

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute, LINEAR)
```

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml007 | 2016-06-03T09:20:00.000Z      | 18           |
| nurswgvml007 | 2016-06-03T09:25:00.000Z      | 8            |
| nurswgvml007 | 2016-06-03T09:30:00.000Z      | 7            |  + interpolated +
| nurswgvml007 | 2016-06-03T09:35:00.000Z      | 6            |
| nurswgvml007 | 2016-06-03T09:40:00.000Z      | 19           |
| nurswgvml007 | 2016-06-03T09:45:00.000Z      | 19           |
```

## Linear Interpolation, 1 Minute Period, Multiple Periods

```sql
SELECT entity, date_format(PERIOD(1 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(1 minute, LINEAR)
```

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml006 | 2016-06-03T09:25:00.000Z      | 4.00         |
| nurswgvml006 | 2016-06-03T09:26:00.000Z      | 4.00         |
| nurswgvml006 | 2016-06-03T09:27:00.000Z      | 3.92         | + interpolated +
| nurswgvml006 | 2016-06-03T09:28:00.000Z      | 3.83         | + interpolated +
| nurswgvml006 | 2016-06-03T09:29:00.000Z      | 3.75         | + interpolated +
| nurswgvml006 | 2016-06-03T09:30:00.000Z      | 3.67         | + interpolated +
| nurswgvml006 | 2016-06-03T09:31:00.000Z      | 3.58         | + interpolated +
| nurswgvml006 | 2016-06-03T09:32:00.000Z      | 3.50         | + interpolated +
| nurswgvml006 | 2016-06-03T09:33:00.000Z      | 3.42         | + interpolated +
| nurswgvml006 | 2016-06-03T09:34:00.000Z      | 3.33         | + interpolated +
| nurswgvml006 | 2016-06-03T09:35:00.000Z      | 3.25         | + interpolated +
| nurswgvml006 | 2016-06-03T09:36:00.000Z      | 3.17         | + interpolated +
| nurswgvml006 | 2016-06-03T09:37:00.000Z      | 3.08         | + interpolated +
| nurswgvml006 | 2016-06-03T09:38:00.000Z      | 3.00         |
| nurswgvml006 | 2016-06-03T09:39:00.000Z      | 3.00         |
```

## Interpolation with Constant (Fill Gaps)

Note that interpolation is applied before the rows are filtered with the `HAVING` condition.

```sql
SELECT entity, date_format(PERIOD(5 minute)), COUNT(value)
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-03T09:20:00.000Z' AND datetime < '2016-06-03T09:50:00.000Z'
  AND entity = 'nurswgvml006'
GROUP BY entity, PERIOD(5 minute, VALUE 0)
  HAVING COUNT(value) > 10
```

```ls
| entity       | date_format(period(5 MINUTE)) | COUNT(value) |
|--------------|-------------------------------|--------------|
| nurswgvml006 | 2016-06-03T09:20:00.000Z      | 18.00        |
| nurswgvml006 | 2016-06-03T09:40:00.000Z      | 19.00        |
| nurswgvml006 | 2016-06-03T09:45:00.000Z      | 19.00        |
```

Interpolated periods at 09:25:00, 09:30:00, 09:35:00 are still not displayed since they have been excluded with `HAVING COUNT(value) > 10` condition.
