# Variables

## Overview

Variables are defined on the **Overview** tab and consist of a unique name and an expression.

![](images/variables.png)

## Usage

### Condition

The user-defined variables can be referenced in the rule [condition](condition.md).

![](images/variables-condition.png)

### Response Actions

Similar to the built-in window [placeholders](placeholders.md), the variables can be also included by name in the notifications messages, system commands, and logging messages:

```sh
${busy}
```

![](images/variables-refer.png)

### Filter

Variables **cannot** be included in the [filter](filters.md) expression because filters are evaluated prior to the command is assigned to windows.

## Data Types

### double

  ```javascript
  pival = 3.14
  ```

### integer

  ```javascript
  kb = 1024
  ```  

### long

  ```javascript
  curtime = 1515758392702
  ```  

### string

  ```javascript
  state = 'CA'
  ```

Single or double quotes must be used when declaring a string variable.

### list

The list can include elements of different types.

  ```javascript
  errorCodes = [401, 403, 404]
  ```  

Both single and double quote can be used to specify string elements.   

  ```javascript
  stateList = ['CA', 'WA']
  ```

  ```javascript
  stateList = ["CA", "WA"]
  ```  

### map

  ```javascript
  stateMap = ['CA': 0.8, 'WA': 0.2]
  ```

  ```javascript
  stateMap = ["CA": 0.8, "WA": 0.2]
  ```

  > Both single and double quote can be used to specify map keys and values.

### function

  ```javascript
  last_msg = db_message_last('1 week', 'alert', 'rule-engine')
  ```

  ```javascript
  since_start = formatIntervalShort(elapsedTime(property('dkr.state::started')))
  ```  

  ```javascript
  server = upper(keepBefore(entity, ':'))
  ```  

### expression

  ```javascript
  annotation = tags.note == null ? 'N/A' : tags.note
  ```

## Cross-Reference

The variables can refer to other variables declared in the same rule.

![](images/variables-reference.png)

The variables are evaluated in the order defined on the **Overview** tab.

The dependent variable must be declared **after** the variable that it refers to.

## Execution

The variables are evaluated for each incoming command regardless of the window status.

If the variable invokes an external function such as [`scriptOut`](functions-script.md) it must execute quickly (less than a few seconds). The long-running functions should not be included in variables.

The current value of variables can be accessed on the window detail page.

![](images/variables-window-2.png)

![](images/variables-window.png)
