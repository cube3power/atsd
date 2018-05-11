# Limit

## Query - First Values

```sql
SELECT * FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime > previous_hour AND datetime < current_hour
ORDER BY datetime
  LIMIT 3
```

## Results

```ls
| entity       | datetime                 | value |
|--------------|--------------------------|-------|
| nurswgvml006 | 2016-07-15T09:00:01.000Z | 36.2  |
| nurswgvml006 | 2016-07-15T09:00:17.000Z | 30.8  |
| nurswgvml006 | 2016-07-15T09:00:33.000Z | 7.0   |
```

## Query - First Values With Offset

An offset starts with 0. `LIMIT 0, n` is the same as `LIMIT n`.

`LIMIT 1, 3` or `LIMIT 3 OFFSET 1` returns 3 rows starting with the 2nd row.

```sql
SELECT * FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime > previous_hour AND datetime < current_hour
ORDER BY datetime
  LIMIT 1, 3
```

Using the `OFFSET` clause produces the same result:

```sql
SELECT * FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime > previous_hour AND datetime < current_hour
ORDER BY datetime
  LIMIT 1 OFFSET 3
```

## Results

```ls
| entity       | datetime                 | value |
|--------------|--------------------------|-------|
| nurswgvml006 | 2016-07-15T09:00:17.000Z | 30.8  |
| nurswgvml006 | 2016-07-15T09:00:33.000Z | 7.0   |
| nurswgvml006 | 2016-07-15T09:00:49.000Z | 12.1  |
```

## Query - Last Values

```sql
SELECT * FROM "mpstat.cpu_busy"
WHERE entity = 'nurswgvml006'
  AND datetime > previous_hour AND datetime < current_hour
ORDER BY datetime DESC
  LIMIT 3
```

## Results

```ls
| entity       | datetime                 | value |
|--------------|--------------------------|-------|
| nurswgvml006 | 2016-07-15T09:59:50.000Z | 4.0   |
| nurswgvml006 | 2016-07-15T09:59:34.000Z | 10.3  |
| nurswgvml006 | 2016-07-15T09:59:18.000Z | 17.5  |
```
