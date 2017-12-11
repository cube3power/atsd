# Condition

Condition is a boolean expression which is evaluated when data is received by or removed from the window. For example, the condition `value > 50` returns `true` if the last received value exceeds 50.

The condition consists of one or multiple boolean checks combined with `OR` (`||`), `AND` (`&&`) and `NOT` (`!`) operators.

The expressions can reference the command, window, entity and metric fields, user-defined variables and apply [functions](functions.md) to data.

When the condition evaluates to `true` for the first time, the [window](window.md) status changes to `OPEN` causing the execution of 'On Open' triggers. Once the condition becomes `false`, the window returns back to `CANCEL` status triggering a corresponding set of triggers.

## Overrides

Exceptions specified in the [`Overrides`](overrides.md) table take precedence over the condition.

## Fields

| **Field** | **Description** |
| :--- | :--- |
| `value` | Last data sample. |
| `tags.{tag_name}` | Value of command tag 'tag_name', for example, `tags.file_system`. <br>Also, `tags['tag_name']`.|
| `entity` | Entity name. |
| `entity.label` | Entity label. |
| `entity.{field_name}` | Entity [field](../api/meta/entity/list.md#fields) with the specified name, for example `entity.timeZone`. |
| `entity.tags.{tag_name}` | Entity tag value, for example, `entity.tags.location`. <br>Also, `entity.tags['tag_name']`. |
| `metric` | Metric name. |
| `metric.label` | Metric label. |
| `metric.{field_name}` | Metric [field](../api/meta/metric/list.md#fields) with the specified name, for example `metric.retentionDays`. |
| `metric.tags.{tag_name}` | Metric tag value, for example, `metric.tags.units`. <br>Also, `metric.tags['tag_name']`. |
| `property(search)` | Property key/tag value based on property search syntax. Refer to [property functions](functions.md#property-functions). |

## Boolean Operators

| **Name** | **Description** |
| :--- | :--- |
| `OR` | Boolean OR, also `\|\|`. |
| `AND` | Boolean AND, also `&&`. |
| `NOT` | Boolean NOT, also `!`. |

## Numeric Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Equal.
| `!=` | Not equal.
| `>` | Greater than.
| `>=` | Greater than or equal.
| `<` | Less than.
| `<=` | Less than or equal.
| `BETWEEN` | `a BETWEEN b AND c`.<br>The number `a` is between `b` and `c` (inclusive).<br>`b <= a <= c`.<br>Example: `avg() BETWEEN 10 and 20`.

## Text Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Equal. The comparison is case-**insensitive** ('a' = 'A' equals `true`).|
| `!=` | Not equal. The comparison is case-**insensitive** ('a' != 'A' equals `false`).|
| `BETWEEN` | `a BETWEEN b AND c`.<br>String `a` is between `b` and `c` (inclusive) using lexicographical comparison.<br>The comparison is case-**sensitive**.<br>Example: `timeStr BETWEEN '18:00' AND '18:04'`.|

## Functions

Refer to [functions](functions.md).

Function names are **case-sensitive**.

## Variables

Functions that return a primitive value (number, string, boolean) can be defined as a variable and included in the condition expression by name.

## Examples

### Basic Threshold

The condition is `true` when the last value is greater than `75`.

```javascript
  value > 75
```

### Threshold Range

The condition is `true` when the last value is between `75` and `90`, exclusive of the boundaries.

```javascript
  value > 75 && value < 90
```

### Last-N Average

For a count-based window with the length of 5 samples, the condition is `true` when average of values in the window is greater than `75`.

```javascript
  avg() > 75
```

The number of values in the window is less than `5` from the time the window is started and until it reaches the maximum capacity as new data arrives. For example, the `avg()` function will return the same result as `value` when the first sample arrives.

### Latest-N Average

For a time-based window with a duration of 5 minutes, the condition is `true` when average of values with timestamps greater than current time minus window duration exceeds `75`.

```javascript
  avg() > 75
```

The number of samples in the window can range from 0 (when the oldest value exits the window) to unlimited.

### All Values Are Above Threshold

The condition is `true` when the all values in the window, both count- and time-based, exceed `50`.

```javascript
  min() > 50
```

### Equal Values

The condition is `true` when all values in the window are equal.

```javascript
  max() - min() = 0
```

### Equal Number

The condition is `true` when all values in the window are equal `50`.

```javascript
  max() - min() = 0 && avg() = 50
```
