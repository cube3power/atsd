# Mathematical Functions

Math functions are supported in the `SELECT` expression and within `WHERE`, `HAVING`, and `ORDER BY` clauses.

## Query

```sql
SELECT value, ABS(value), CEIL(value), FLOOR(value), ROUND(value), MOD(value, 3),
  POWER(value, 2), EXP(value), LN(value), LOG(10, value), SQRT(value),
  LN(value*2), MOD(CEIL(value)*2, 4)
  FROM "mpstat.cpu_busy"
WHERE datetime >= now - 5 * minute
  AND entity = 'nurswgvml007'
  AND FLOOR(value) > 10
  ORDER BY SQRT(value) DESC
```

## Results

```ls
| value  | ABS(value) | CEIL(value) | FLOOR(value) | ROUND(value) | MOD(value,3) | POWER(value,2) | EXP(value)     | LN(value) | LOG(10,value) | SQRT(value) | LN(value*2) | MOD(CEIL(value)*2,4) | 
|--------|------------|-------------|--------------|--------------|--------------|----------------|----------------|-----------|---------------|-------------|-------------|----------------------| 
| 21.000 | 21.000     | 21.000      | 21.000       | 21.000       | 0.000        | 441.000        | 1318815734.483 | 3.045     | 1.322         | 4.583       | 3.738       | 2.000                | 
| 11.000 | 11.000     | 11.000      | 11.000       | 11.000       | 2.000        | 121.000        | 59874.142      | 2.398     | 1.041         | 3.317       | 3.091       | 2.000                | 
```
