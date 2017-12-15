# Value Functions

## Overview

The value functions retrieve the value of other metrics submitted within the same series command or parsed from the same row in the CSV file.

## `value` Function

* Retrieve the value for the specified metric received in the same series command.

```java
  value(S metric)
```

Example:

```java
  value > 1.5 && value('temperature') > 50
```

```ls
series e:sensor01 m:pressure=3.5 m:temperature=80
```

Assuming the rule was created for the `pressure` metric, the condition will evaluate to `true` for the above series command.

```ls
3.5 > 1.5 && 80 > 50
```

Compared to the [`db_last`](functions-db.md) function, which queries the database, the `value()` function returns the value as specified in the command, even if the requested metric value is not yet committed to the database.
