# Derived Commands

## Overview

The derived command action allows storing new calculated metrics in the database by creating and processing custom commands in the [Network API](../api/network#network-api) syntax.

## Command Template

When configuring a command action, you need to specify a command template consisting of command fields and placeholders.

```ls
series e:${entity} m:jvm_memory_free_avg_percent=${round(100 - avg(), 3)}
```

Multiple commands can be specified at the same time. Each command must be specified on a separate line.

## Condition

If creating new data is the only purpose of the rule, set the `Condition` field to a static value `true` in order to minimize processing overhead.

![](images/derived-condition.png)

## Placeholders

The `${commandTags}` placeholder prints out all window tags in the Network API syntax. It allows appending tags to the command without knowing the tag names in advance.

```ls
series e:${entity} m:disk_free=${100 - value} ${commandTags}
```
