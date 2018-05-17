# Placeholders

## Overview

Placeholders can be used to include contextual information in email messages, web notifications, system commands, and logging messages.

![](./images/placeholders-email.png)

## Syntax

The placeholder is declared with the dollar sign `$` and curly braces `{}`.

```php
  ${expression}
```

When the response action is triggered, the expression between the braces is resolved to a concrete value based on the window context.

The replacements in the original input text, such as email subject, are performed _in-place_ where each placeholder is substituted with the value of its expression, converted to a string.

The expression may refer to:

* Literal values (constants) of different [data types](variables.md#data-types)
* [Window](window.md#window-fields) fields
* [Entity](../api/meta/entity/list.md#fields) fields
* User-defined [variables](variables.md)
* [Function](functions.md) results

Unknown fields and variables are evaluated to `null`.

If the expression itself evaluates to `null`, the placeholder is substituted with an **empty** string.

If the expression cannot be evaluated due to an error, the placeholder is left unchanged and an error message is presented on the **Rule Errors** page.

## Examples

```css
ActiveMQ on ${entity} recorded unauthorized connection from ${tags.remoteaddress}.
```

```txt
ActiveMQ on nurswgvml007 recorded unauthorized connection from 10.102.0.106.
```

---

```css
Average CPU usage on ${entity} is high: ${round(avg()*100,1)}%
```

```txt
Average CPU usage on nurswgvml007 exceeds threshold: 70.2%
```

---

```css
File System '${tags.file_system}' is low on disk space: ${value} (used)
```

```txt
File System '/opt/apps' is low on disk space: 95.567 (used)
```

---

```css
Server ${entity.label}/${entity} located at site ${lower(entity.tags.location)} is shutting down.
```

```txt
Server Apps-NUR/nurswgvml007 located at site NUR is shutting down.
```
