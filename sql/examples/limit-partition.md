## LIMIT by Partition

The last record in each partition can be retrieved by reverse ordering rows within each partition using the `ORDER BY time DESC` condition.

### Query

```sql
SELECT entity, datetime, value
  FROM "mpstat.cpu_busy"
WHERE datetime >= '2016-06-18T12:00:00.000Z' AND datetime < '2016-06-18T12:00:30.000Z'
  WITH ROW_NUMBER(entity ORDER BY time DESC) <= 1
  ORDER BY entity, time
```

### Results

```ls
| entity       | datetime                 | value | 
|--------------|--------------------------|-----:| 
| nurswgvml006 | 2016-06-18T12:00:21.000Z | 8.1  | 
| nurswgvml007 | 2016-06-18T12:00:19.000Z | 67.7 | 
| nurswgvml010 | 2016-06-18T12:00:14.000Z | 0.5  | 
| nurswgvml011 | 2016-06-18T12:00:26.000Z | 4.0  | 
| nurswgvml102 | 2016-06-18T12:00:18.000Z | 0.0  | 
| nurswgvml502 | 2016-06-18T12:00:17.000Z | 0.5  | 
```
