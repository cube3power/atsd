# `GROUP BY` Query with `HAVING`

## Query

```sql
SELECT entity, avg(value), count(*)
  FROM "mpstat.cpu_busy" 
WHERE datetime > now - 1* hour
  GROUP BY entity
HAVING avg(value) > 10 AND count(*) > 200
```

## Results

```ls
| entity       | avg(value)         | count(*) |
|--------------|--------------------|----------|
| awsswgvml001 | 13.290133333333332 | 225.0    |
| nurswgvml006 | 21.918035714285715 | 224.0    |
| nurswgvml007 | 47.27337777777781  | 225.0    |
```
