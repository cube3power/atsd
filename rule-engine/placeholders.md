# Placeholders

## Overview

Placeholders can be used to include [window](window.md) fields and [function](function.md) values into email notifications, web notifications, system commands, and logging messages.

The placeholders can be specified using the `${name}` syntax which is replaced with the actual value of the variable or the function at the time the trigger is executed.

![](images/placeholders.png)

If the placeholder doesn't exist, it is substituted with an empty string.

## Generic Placeholders

**Name**|**Example**
:---|:---
alert_type | OPEN
entity | atsd
entity_label | Axibase TSD
entity_tags | {version=community}
entity_tags.tag_name | community
event_tags | {location=dc-5}
condition | value < 512*1024*1024
metric | jvm_memory_free
min_interval_expired | true
open_value | 3103100000
repeat_count | 0
repeat_interval | 1 MINUTE
rule | memory_low
rule_filter | entity != 'nurswghbs001'
rule_name | memory_low
severity | warning
status | OPEN
tags.tag_name | nurswgvml003
tags | host=nurswgvml003
value | 3103100000
window | length(1)
threshold | max() > 20

## Series Placeholders

* open_value
* value

## Message Placeholders

* message
* severity

## Properties Placeholders

* properties
* properties.key_name
* properties.tag_name
* type

## Time Placeholders

* alert_duration
* alert_duration_interval
* alert_open_time
* alert_open_datetime
* received_time
* received_datetime
* event_time
* event_datetime
* window_first_time
* window_first_datetime

> Placeholders ending with `_time` contain time in local server timezone, for example 2017-05-30 14:05:39 PST.
> Placeholders ending with `_datetime` contain time in ISO 8601 format in UTC timezone, for example 2017-05-30T06:05:39Z.

## Link Placeholders

* ruleLink
* chartLink
* csvExportLink
* htmlExportLink

## Placeholder for Custom Variables

Variables defined on the 'Overview' tab can be referenced by name, similar to the built-in fields.

```sh
${idle}
```

![](images/variables.png)

## Examples

```sh
[${status}] ActiveMQ on ${entity}:
Unauthorized connection from ${tags.remoteaddress}.
```

```sh
[${status}] JVM on ${entity}:
Average CPU usage ${round(avg()*100,1)} exceeds threshold.
```

```sh
${tags.file_system}
```

```sh
${entity.tags.location}
```

```sh
${tags}
```
