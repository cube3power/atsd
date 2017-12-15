# Value Functions

## Overview

The value functions retrieve the value of other metrics submitted within the same series command or parsed from the same row in CSV files.

## `value` Function

* Retrieve the last value for the specified metric received in the same series command.

```java
  value(S metric)
```

  Example:

```java
  avg() > 60 && value('temperature') < 30
```

Compared to the [`db_last`](functions-db.md) function, which queries the database, the `value()` function returns the value as specified in the command, even if the requested metric value is not yet committed to the database.
