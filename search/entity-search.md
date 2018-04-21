# Entity Search

## Overview

The entity search interface can find entities by name or entity tag values.

## Syntax

A keyword without a colon is considered an entity name filter, a keyword containing a colon is treated as a tag name.

```ls
name-filter [tag-name-1:tag-value-2] [tag-name-2:tag-value-2]
```

The `*` wildcard is automatically appended to the `name-filter`, thereby including entities with a name **starting** with the specified text.

If the search expression contains a tag name, such tags are displayed in the results table.

## Wildcards

* `*` matches any number of characters.
* `?` matches any one character.

## Match

Entity names, tag names and tag values are matched in case-insensitive manner.

## Examples

* Find entities starting with `nur`

```ls
nur
```

* Find entities starting with `nur`

```ls
nur*
```

* Find entities containing `nur`

```ls
*nur*
```

* Find entities with tag `location` set to `SVL`


```ls
location:SVL
```

* Find entities with any value for tag `location` (display `location` column).


```ls
location:*
```

* Find entities with non-empty value for tag `location`.


```ls
location:*
```

* Find entities starting with `nur` **and** tag `location` set to `SVL`


```ls
nur location:SVL
```
