# Aggregate - Average Value

Average value for one metric, one entity.

## Query

```sql
SELECT avg(value)
 FROM "mpstat.cpu_busy" 
WHERE entity = 'nurswgvml007' 
 AND datetime >= current_day
```

## Results

```ls
| entity       | avg(value) | 
|--------------|------------| 
| nurswgvml007 | 11.3       | 
```

## Query

Multiple functions.

```sql
SELECT avg(value), max(value), last(value), count(*)
 FROM "mpstat.cpu_busy" 
WHERE entity = 'nurswgvml007' 
 AND datetime >= current_day
```

## Results

```ls
| entity       | avg(value) | max(value) | last(value) | count(*) | 
|--------------|------------|------------|-------------|----------| 
| nurswgvml007 | 12.8       | 100.0      | 16.5        | 3316.0   | 
```
