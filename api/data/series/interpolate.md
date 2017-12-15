# Interpolation

## Overview

The transformation creates a regularized time series with the specified period by calculating values at each timestamp from neighboring samples using linear or step functions.

## Interpolation Process

1. Create an array of evenly spaced timestamps with the specified period and aligned either to calendar or start/end time.
2. Load detailed data for the selection interval specified with `startDate` and `endDate` parameters.
3. If `OUTER` boundary mode is enabled, load one value before and one value after the selection interval in order to interpolate leading and trailing values.
4. For each timestamp, calculate the value from the two neighboring values using the specified interpolation function.
5. If `fill` is enabled, add missing leading and trailing values.

## Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| [function](#function) | string | [**Required**] `PREVIOUS`, `LINEAR`, or `AUTO`. |
| [period](#period) | object | [**Required**] Repeating time interval. |
| [boundary](#boundary) | string | Controls if loading of values outside of the selection interval. |
| [fill](#fill) | string | Creates missing leading and trailing values. |

### function

| **Name** | **Description**   |
|:---|:---|
| `LINEAR`  | [**Default**] Calculates the value by adding a difference between neighboring detailed values proportional to their time difference. |
| `PREVIOUS`  | Sets the value to equal the previous value. |
| `AUTO`  | Applies the interpolation function specified in the metric's [interpolate](../../meta/metric/list.md#fields) field (set to `LINEAR` by default).  |

### period

[Period](period.md) is a repeating time interval used to create evenly spaced timestamps.

| **Name**  | **Type** | **Description** |
|:---|:---|:---|
| unit  | string | [Time unit](time-unit.md) such as `MINUTE`, `HOUR`, `DAY`. |
| count  | number | Number of time units contained in the period. |
| align | string | Alignment of the first or last timestamp. Default: [`CALENDAR`](period.md#calendar-alignment).|
| timezone | string | [Time Zone ID](../../network/timezone-list.md) for aligning timestamps in [`CALENDAR`](period.md#calendar-alignment) mode.<br>The default value is equal to the database timezone.|

Examples:

* `{ "count": 1, "unit": "HOUR" }`
* `{ "count": 15, "unit": "MINUTE", "align": "END_TIME" }`

### boundary

| **Name** | **Description**   |
|:---|:---|
| `INNER`  | [**Default**] Do not load data outside of the selection interval. |
| `OUTER`  | Load one value before and one value after the selection interval in order to interpolate leading and trailing values. |

Examples:

* `{ "boundary": "OUTER" }`

### fill

| **Name** | **Description**   |
|:---|:---|
| `false`  | [**Default**] Do not add missing values. |
| `true`  | Add missing leading values by setting them to the first available detailed value.<br>Add missing trailing values by setting them to the last available detailed value.|
| `{n}`  | Add missing leading and trailing values by setting them to the specified number `{n}`.<br>The number `{n}` can be any decimal number as well as "NaN" string (Not a Number). |

Examples:

* `{ "fill": false }`
* `{ "fill": true }`
* `{ "fill": 0 }`
* `{ "fill": "NaN" }`

## Examples

* 5-minute linear interpolation

```json
{
    "interpolate" : {
        "function": "LINEAR",
        "period": {"count": 5, "unit": "MINUTE"},
        "boundary": "OUTER",
        "fill": false,
    }
}
```
