# Getting Started: Part 5

### SQL

Open [SQL] tab in the top menu.

Enter the following query:

```sql
SELECT entity, metric, datetime, value
  FROM "my-metric"
WHERE entity = 'my-entity'
  AND datetime >= '2017-05-01T00:00:00Z'
ORDER BY datetime
```

![](resources/sql-detailed.png)

Modify the query to add aggregation and groupings:

```sql
SELECT entity, datetime, MAX(value), COUNT(value)
  FROM "my-metric"
WHERE entity = 'my-entity'
  AND datetime >= '2017-05-01T00:00:00Z'
GROUP BY entity, PERIOD(1 HOUR)
  ORDER BY datetime
```

![](resources/sql-grouped.png)

Review the [SQL syntax](../sql/README.md) and experiment by executing your own queries.


### Summary

Congratulations! You have reached the end of the Getting Started introduction to Axibase Time Series Database.
