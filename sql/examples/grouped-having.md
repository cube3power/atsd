# Grouping and Having Filter

In this example the "not equal" operator `!=` is used to exclude grouped rows with aggregation function delta equal to zero from the results.

## Query

```sql
SELECT t1.entity, t2.tags.mount_point AS mp, t2.tags.file_system AS FS,
  MIN(t2.value), MAX(t2.value),  FIRST(t2.value), LAST(t2.value),
  DELTA(t2.value), COUNT(t2.value),  AVG(t1.value)
FROM "mpstat.cpu_busy" t1
  JOIN USING ENTITY "df.disk_used" t2
WHERE t1.datetime > now - 1*HOUR
  GROUP BY entity, t2.tags.mount_point, t2.tags.file_system
HAVING DELTA(t2.value) != 0
  ORDER BY DELTA(t2.value) DESC
```

## Results

```ls
| t1.entity    | MP               | FS                                  | MIN(t2.value) | MAX(t2.value) | FIRST(t2.value) | LAST(t2.value) | DELTA(t2.value) | COUNT(t2.value) | AVG(t1.value) |
|--------------|------------------|-------------------------------------|---------------|---------------|-----------------|----------------|-----------------|-----------------|---------------|
| nurswgvml502 | /                | /dev/sda1                           | 31734552.0    | 31826236.0    | 31734628.0      | 31826088.0     | 91460.0         | 15.0            | 6.0           |
| nurswgvml007 | /                | /dev/mapper/vg_nurswgvml007-lv_root | 8991388.0     | 9080532.0     | 9063596.0       | 9070464.0      | 6868.0          | 15.0            | 9.3           |
| nurswgvml010 | /                | /dev/sda1                           | 7758636.0     | 7760308.0     | 7758636.0       | 7760308.0      | 1672.0          | 15.0            | 0.8           |
| nurswgvml010 | /app             | /dev/sdb1                           | 31428576.0    | 31429544.0    | 31428576.0      | 31429544.0     | 968.0           | 15.0            | 0.8           |
| nurswgvml006 | /                | /dev/mapper/vg_nurswgvml006-lv_root | 5991384.0     | 5992080.0     | 5991384.0       | 5992080.0      | 696.0           | 14.0            | 8.0           |
| nurswgvml301 | /                | /dev/sda1                           | 1502688.0     | 1502724.0     | 1502688.0       | 1502724.0      | 36.0            | 4.0             | 0.8           |
| nurswgvml006 | /media/datadrive | /dev/sdc1                           | 56066388.0    | 56174392.0    | 56174392.0      | 56132312.0     | -42080.0        | 14.0            | 8.0           |
```
