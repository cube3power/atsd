# Window

## Overview

A window is an in-memory structure created by the rule engine for each unique combination of metric, entity, and tags extracted from incoming commands.

## Window Length

### Count Based Windows

**Count-based** windows accumulate up to the specified number of samples. The samples are sorted in order of arrival, with the most recently received sample placed at the end of the array. If the window is full, the first (oldest by arrival time) sample is removed from the window to free up space at the end of the array for an incoming sample. 

Example

![Count Based Window](images/count_based_window3.png "count_based_window")

### Time Based Windows

**Time-based** windows store samples that were recorded within the specified interval of time, ending with the current time. The time-based window doesn't limit how many samples are held by the window. Its time range is continously updated. Old records are automically removed from the window once they're outside of the time range.

![Time Based Window](images/time_based_window3.png "time_based_window")

## Window Status

The response actions are triggered on window status events.

As the new data is received and old data is removed from the window, the rule engine re-evaluates the expression which can cause the status of the current window to change, triggering actions.

### Initial Status

New windows are created based on incoming data and no historical data is loaded from the database.

The window for the given metric/entity/tags is created only when the first command for this series is received by the rule engine.

The new windows are assigned initial status of `CANCEL` which is then updated based on results of the boolean expression (`true` or `false`).

### Window Lifecycle

All windows for the current rule are deleted from memory if the rule is deleted or modified and saved in the editor.

### Triggers

The actions can be triggered whenever the window changes its status as well as at scheduled intervals when the status is `REPEAT`.

### Status Events

| Previous State | New Status | Previous Expression Value | New Expression Value | Trigger Supported |
| --- | --- | --- | --- | --- |
| `CANCEL` | `OPEN` | `false` | `true` | Yes |
| `OPEN`  | `REPEAT` | `true` | `true` | Yes |
| `REPEAT` | `REPEAT` | `true` | `true` | Yes |
| `OPEN` | `CANCEL` | `true` | `false` | Yes |
| `REPEAT` | `CANCEL` | `true` | `false` | Yes |
| `CANCEL` | `CANCEL` | `false` | `false` | No |

### `OPEN` Status

The `OPEN` status is assigned to the window when the expression changes value from `false` to `true`.

### `REPEAT` Status

The `REPEAT` status is assigned to an `OPEN` window when the expression returns `true` based on the second received command.

When the window is in `REPEAT` status, the actions can be executed with the frequency specified in the rule editor.

### `CANCEL` Status

`CANCEL` is the initial status assigned to new windows. It is also assigned to the window when the the boolean expression changes from `true` to `false` or when the window is deleted on rule modification.

Triggering a repeat action in `CANCEL` status is not supported. Such behavior can be emulated by creating a separate rule with a negated expression which returns `true` instead of `false` for the same condition.

