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

The calculated metrics can reference other metrics using `db_last` and `db_statistic` functions.

```ls
series e:${entity} m:jvm_memory_used_bytes=${value * db_last('jvm_memory_total_bytes') / 100.0}
```

A special placeholder `${commandTags}` is provided to print out all window tags in the Network API syntax. It includes all tags to the command without knowing the tag names in advance.

```ls
series e:${entity} m:disk_free=${100 - value} ${commandTags}
```

Multiple commands can be specified at the same time. Each command must be specified on a separate line.

```ls
series e:${entity} m:jvm_memory_free_avg_percent=${round(100 - avg(), 3)}
series e:${entity} m:jvm_memory_free_min_percent=${round(100 - max(), 3)}
```

## Frequency

The derived commands can be executed at the same frequency as incoming commands or increased by adjusting the repeat interval.

![](images/derived_repeat.png)

## Condition

If creating new data is the only purpose of the rule, set the `Condition` field to a static value `true` in order to minimize processing overhead.

![](images/derived-condition.png)
