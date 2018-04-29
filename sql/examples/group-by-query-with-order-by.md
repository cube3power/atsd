# `GROUP BY` Query with `ORDER BY`

## Query

```sql
SELECT entity, avg(value)
  FROM "mpstat.cpu_busy"
WHERE datetime > now - 1*hour
  GROUP BY entity
  ORDER BY avg(value) DESC
```

## Results

```ls
| entity       | avg(value)         |
|--------------|-------------------:|
| nurswgvml007 | 46.547288888888865 |
| nurswgvml006 | 21.85551111111111  |
| awsswgvml001 | 13.554488888888887 |
| nurswgvml010 | 7.88160714285714   |
| nurswgvml011 | 2.8021973094170405 |
```
