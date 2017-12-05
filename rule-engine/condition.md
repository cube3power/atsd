# Condition

Condition is a boolean expression specified in the [rule editor](editor.md) which is evaluated when data is
received by or removed from the window. For example, the condition `value > 50` returns `true` if the last received value exceeds 50.

When the condition evaluates to `true` for the first time, the window status changes to `OPEN` causing the execution of 'On Open' triggers such as a system commands and email notifications. Once the condition becomes `false`, the window returns back to `CANCEL` status triggering a corresponding set of triggers.

The condition consists of one or multiple boolean checks combined with `OR` (`||`), `AND` (`&&`) and `NOT` (`!`) operators.

The expressions can reference rule, command, and window fields, user-defined variables and apply [functions](functions.md) to data. 

> Exceptions specified in the `Overrides` table take precedence over the condition.

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

## Text Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Equal. |
| `!=` | Not equal. |

> Note: `=` and `!=` operators are case-insensitive.

## Functions

Refer to [functions](functions.md).

Function names are **case-sensitive**.

## Variables

Functions that return a primitive value (number, string, boolean) can be defined as a variable and included in the condition expression by name.


## Examples

| **Type** | **Window** | **Example** | **Description** |
| --- | --- | --- | --- |
| threshold | none | `value > 75` | Raise an alert if last metric value exceeds threshold. |
| range | none | `value > 50 AND value <= 75` | Raise an alert if value is outside of specified range. |
| statistical-count | count(10) | `avg() > 75` | Raise an alert if average value of the last 10 samples exceeds threshold. |
| statistical-time | time('15 min') | `avg() > 75` | Raise an alert if average value for the last 15 minutes exceeds threshold. |
