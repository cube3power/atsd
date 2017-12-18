# Database Functions

## Overview

* [`db_last()`](functions-db.md#db_last-function)
* [`db_statistic()`](functions-db.md#db_last-function)
* [`db_message_count()`](functions-db.md#db_message_count-function)
* [`db_message_last()`](functions-db.md#db_message_last-function)

The `db_last` and `db_statistic` functions provide a way to retrieve the last detailed or averaged value stored in the database for a series which may be different from the series in the current window. The functions can be used to compare different series for correlation purposes.

* The `db_last` function retrieves the last value stored in the database for the specified series.
* The `db_statistic` function retrieves an aggregated value from the database for the specified series.

The `db_message_count` and `db_message_last` functions allow one to correlate different types of data - time series and messages.

## `db_last` Function

* Retrieve the last value for the specified metric and the same entity and tags as defined in the current window.

```java
  db_last(S metric)
```

  Example:

```java
  value > 60 && db_last('temperature') < 30
```

> As an alternative, if the specified metric was received in the same command, use [`value()`](functions-value.md) function. The `value()` function returns metric values set in the command, even if they're not yet stored in the database.

* Retrieve the last value for the specified metric and entity. The entity can specified as a string or as `entity` placeholder.

```java
db_last(S metric, S entity)
```

  Example:

```java
  value > 60 && db_last('temperature', 'sensor-01') < 30

  // same as db_last('temperature')
  value > 60 && db_last('temperature', entity) < 30
```

* Retrieve the last value for the specified metric, entity, and series tags. The tags can be specified as an empty string `''` (no tags), as `key1=value1,key2=value`, or as `tags` placeholder representing the tags of the current window.

```java
  db_last(S metric, S entity, S tags)
  db_last(S metric, S entity, Map tags)
```

  Example:

```java
  value > 60 && db_last('temperature', 'sensor-01', 'stage=heating') < 30
```

## `db_statistic` Function

The first required argument accepts a [statistical function](`../api/data/aggregation.md`) name such as `avg` which is applied to values within the selection interval.

The second required argument is the duration of selection interval specified as `count unit`, for example, '1 HOUR'. The end of the selection interval is set to current time.

* Retrieve an aggregated value from the database for the same metric, entity and tags as defined in the current window.

```java
  db_statistic(S statistic, S interval)
```

  Example:

```java
  value > 60 && db_statistic('avg', '3 hour') > 30
```

* Retrieve an aggregated value from the database for the specified metric and the same entity and series tags as defined in the current window.

```java
  db_statistic(S statistic, S interval, S metric)
```

  Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature') < 50
```

* Retrieve an aggregated value from the database for the specified metric and entity. The entity can specified as a string or as `entity` placeholder.

```java
  db_statistic(S statistic, S interval, S metric, S entity)
```

  Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

* Retrieve an aggregated value from the database for the specified metric, entity, and series tags. The tags can be specified as an empty string `''` (no tags), as `key1=value1,key2=value`, or as `tags` placeholder representing the tags of the current window.

```java
  db_statistic(S statistic, S interval, S metric, S entity, S tags)
  db_statistic(S statistic, S interval, S metric, S entity, Map tags)
```

  Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', '') < 50
```


## Series Match

Both functions search the database for matching series based on the specified metric/entity/tags filter and return a numeric value for the first matched series. If the series in the current window has tags which are not collected by the specified metric and entity, such tags are excluded from the filter.

### Example `Tags : No Tags`

In the example below, the `db_last('cpu_busy')` function ignores mount_point and file_system tags because these tags are not collected by the cpu_busy metric.

* Current Window

```
  metric = disk_used
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

* Expression

```java
  db_last('cpu_busy') > 10
```

* Search Filter

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Matched Series

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = no tags
```

### Example `Same Tags`

In the example below, the `db_last('disk_used_percent')` function uses the same series tags as in the current window because all of these tags are collected by the disk_used_percent metric.

* Current Window

```
  metric = disk_used
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

* Expression

```java
  db_last('disk_used_percent') > 90
```

* Search Filter

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

* Matched Series

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

### Example `No Tags : Tags`

In the example below, the `db_last('disk_used_percent')` function will search for first series with **any** tags (including no tags) because the cpu_busy metric in the current window has no tags. This search will likely match multiple series, the first of which will be used to return the value. To better control which series is matched, use `db_last('disk_used_percent', entity, 'mount_point=/')` syntax option.

* Current Window

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Expression

```java
  db_last('disk_used_percent') > 90
```

* Search Filter

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Matched Series

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

### Example `Different Tags`

In the example below, the `db_last('io_disk_percent_util')` function will search for first series with **any** tags (including no tags) because the io_disk_percent_util and disk_used metrics have different non-intersecting tag sets. This search will likely match multiple series, the first of which will be used to return the value. To better control which series is matched, use `db_last('io_disk_percent_util', entity, 'device=sda')` syntax option.

* Current Window

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point = /, file_system = /sda
```

* Expression

```java
  db_last('io_disk_percent_util') > 90
```

* Search Filter

```
  metric = io_disk_percent_util
  entity = nurswgvml007
  tags   = [empty - no tags - because there are no intersecting tag names]
```

* Matched Series

```
  metric = io_disk_percent_util
  entity = nurswgvml007
  tags   = device = sda
```

---


## `db_message_count` Function

* Calculate the number of messages matching the specified parameters.

```java
  db_message_count(S interval, S type, S source [, S tags, [S entity]])
```

> `tags` and `entity` arguments are optional.
> If the `type`, `source`, or `tags` fields are set to empty string, they are ignored when matching messages.
> If the `entity` is not specified, the request retrieves messages for the current entity.

  Example:

```java
  // Check if the average exceeds 20 and the 'compaction' message was not received within the last hour for the current entity.
  avg() > 20 && db_message_count('1 hour', 'compaction', '') == 0
```

```java
  // Check if the average exceeds 80 and there is an event with type=backup-error received within the last 15 minutes for entity 'nurswgvml006'.
  avg() > 80 && db_message_count('15 minute', 'backup-error', '', '', 'nurswgvml006') > 0
```

## `db_message_last` Function

* Return the most recent [message](../api/data/messages/query.md#fields-1) object matching the specified parameters.

```java
db_message_last(S interval, S type, S source[, S tags, [S entity]])
```

> `tags` and `entity` arguments are optional.
> If the `type`, `source`, or `tags` fields are set to empty string, they are ignored when matching messages.
> If the `entity` is not specified, the request retrieves messages for the current entity.

The returned object contains `type`, `source`, and `tags.{name}` fields of string type and the `date` field of long data type. The `date` field is returned as epoch milliseconds.

  Example:

```java
  last_msg = db_message_last('60 minute', 'logger', '')
  // Check that the average exceeds 50 and the severity of the last message with type 'logger' for the current entity is greater or equal `ERROR`.
  value > 50 && last_msg != null && last_msg.severity.toString() >= "6"
```
