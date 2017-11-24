# Window

## Overview

A window is an in-memory structure created by the rule engine for each unique combination of metric, entity, and tags extracted from incoming commands.

## Window State

The response actions are triggered on window state events.

As the new data is received and old data is removed from the window, the rule engine re-evaluates the expression which can cause the state of the current window to change, triggering actions.

### Initial State

New windows are created based on incoming data and no historical data is loaded from the database.

The window for the given metric/entity/tags is created only when the first command for this series is received by the rule engine.

The new windows are assigned initial state of `CANCEL` which is then updated based on results of the boolean expression (`true` or `false`).

### Window Lifecycle

All windows for the current rule are deleted from memory if the rule is deleted or modified and saved in the editor.

### Triggers

The actions can be triggered whenever the window changes its state as well as at scheduled intervals when the state is `REPEAT`.

### State Events

| Previous State | New State | Previous Expression Value | New Expression Value | Trigger Supported |
| --- | --- | --- | --- | --- |
| `CANCEL` | `OPEN` | `false` | `true` | Yes |
| `OPEN`  | `REPEAT` | `true` | `true` | Yes |
| `REPEAT` | `REPEAT` | `true` | `true` | Yes |
| `OPEN` | `CANCEL` | `true` | `false` | Yes |
| `REPEAT` | `CANCEL` | `true` | `false` | Yes |
| `CANCEL` | `CANCEL` | `false` | `false` | No |

### `OPEN` State

The `OPEN` state is assigned to the window when the expression changes value from `false` to `true`.

### `REPEAT` State

The `REPEAT` state is assigned to an `OPEN` window when the expression returns `true` based on the second received command.

When the window is in `REPEAT` state, the actions can be executed with the frequency specified in the rule editor.

### `CANCEL` State

`CANCEL` is the initial state assigned to new windows. It is also assigned to the window when the the boolean expression changes from `true` to `false` or when the window is deleted on rule modification.

Triggering a repeat action in `CANCEL` state is not supported. Such behavior can be emulated by creating a separate rule with a negated expression which returns `true` instead of `false` for the same condition.
