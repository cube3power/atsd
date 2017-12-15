# Derived Commands

## Overview

The derived command action allows storing new calculated metrics in the database by creating and processing custom commands defined using the [Network API](../api/network/README.md#network-api) syntax.

## Supported commands:

* [series](../api/network/series.md)
* [property](../api/network/property.md)
* [message](../api/network/message.md)
* [entity](../api/network/entity.md)
* [metric](../api/network/metric.md)

## Command Template

When configuring a command action, you need to specify a template consisting of command name, command fields and command values.

The template can include [placeholders](placeholders.md) and [functions](functions.md).

```ls
series e:${entity} m:jvm_memory_free_avg_percent=${round(100 - avg(), 3)}
```

The calculated metrics can reference other metrics using [`db_last`](functions-db.md#db_last-function) and [`db_statistic`](functions-db.md#db_statistic-function) functions.

```ls
series e:${entity} m:jvm_memory_used_bytes=${value * db_last('jvm_memory_total_bytes') / 100.0}
```

A special placeholder `${commandTags}` is provided to print out all window tags in the Network API syntax. It includes all tags to the command without knowing the tag names in advance.

```ls
series e:${entity} m:disk_free=${100 - value} ${commandTags}
```

Assuming the incoming command was `series e:test m:disk_used=25 t:mount_point=/ t:file_system=sda`:

```ls
series e:test m:disk_free=75 t:mount_point=/ t:file_system=sda
```

The `${timestamp}` placeholder contains the incoming command's timestamp and can be used to preserve the original timestamp in the derived commands.

```ls
series e:${entity} m:disk_free=${100 - value} ${commandTags} ms:${timestamp}
```

Multiple commands, including commands of different type, can be specified at the same time. Each command must be specified on a separate line.

```ls
series e:${entity} m:jvm_memory_free_avg_percent=${round(100 - avg(), 3)}
series e:${entity} m:jvm_memory_free_min_percent=${round(100 - max(), 3)}
```

## Frequency

The derived commands can be stored each time a command is received or removed from the window by setting the **Repeat** parameter to 'All'.

The frequency can be lowered by adjusting the repeat interval.

![](images/derived_repeat.png)

The produced commands are queued in memory and are persisted to the database once per second.

## Condition

If creating new data is the rule's only purpose, set the `Condition` field to a static `true` value to minimize the processing overhead.

![](images/derived-condition.png)
