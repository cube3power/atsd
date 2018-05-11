# Metric Search

## Overview

The metric search interface can find metrics by name or specific metric tag values.

## Syntax

A keyword without a colon is considered a metric name filter, a keyword containing a colon is treated as a tag name.

```ls
name-filter [tag-name-1:tag-value-2] [tag-name-2:tag-value-2]
```

The `*` wildcard is automatically appended to the `name-filter`, thereby including metrics with a name **starting** with the specified text.

If the search expression contains a tag name, such tags are displayed in the results table.

## Wildcards

* `*` matches any number of characters.
* `?` matches any one character.

## Match

Metric names, tag names and tag values are matched in case-insensitive manner.

## Examples

* Find metrics starting with `cpu`

```ls
cpu
```

* Find metrics starting with `cpu`

```ls
cpu*
```

* Find metrics containing `cpu`

```ls
*cpu*
```

* Find metrics with tag `frequency` set to `Daily`

```ls
frequency:Daily
```

* Find metrics with any value for tag `frequency` (display `frequency` column)

```ls
frequency:*
```

* Find metrics with non-empty value for tag `frequency`

```ls
frequency:
```

* Find metrics starting with `cpu` **and** tag `frequency` set to `Daily`

```ls
cpu frequency:Daily
```
