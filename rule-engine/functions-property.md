# Functions: property

## Overview

Property functions provide a set of convenience methods to retrieve and compare property keys and tags.

Refer to [property search](property-search.md) syntax.

## Examples

#### `property_values(string search)`

Returns a list of property tag values for the current entity given the property [search string](property-search.md).

The list is empty if the property or tag is not found.

```java
  property_values('docker.container::image').contains('atsd/latest')
```

```java
  property_values('linux.disk:fstype=ext4:mount_point').contains('/')
```

#### `property_values(string entity, string search)`

Same as `property_values`(String search), except for an explicitly specified entity.

```java
  property_values('nurswgvml007', 'docker.container::image').contains('atsd/latest')
```

```java
  property_values(entity_tags.image, 'docker.image.config::name').contains('atsd/latest')
```

#### `property(string search)`

Returns the first value in the list of strings returned by the `property_values(string search)` function. The function returns an empty string if no property records are found.

```java
  property('docker.container::image')
```

#### `property_compare_except([string key])`

Compares previous and current property tags and returns a difference map containing a list of changed tag values.

Sample difference map:

```java
{inputarguments_19='-Xloggc:/home/axibase/axibase-collector/logs/gc_29286.log' -> '-Xloggc:/home/axibase/axibase-collector/logs/gc_13091.log'}
```

The map includes tags that are not present in new property tags and tags that were deleted.
If the difference map is empty, this means that no changes were identified.
This comparison is case-insensitive.

```java
  NOT property_compare_except (['name', '*time']).isEmpty()
```

Returns true if property tags have changed except for the `name` tag and any tags that end with `time`.

#### `property_compare_except([string currentKey], [string excludeKeys])`

Same as `property_compare_except(keys)` with a list of previous values that are excluded from the difference map.

```java
  NOT property_compare_except(['name', '*time'], ['*Xloggc*']).isEmpty()
```

Returns true if property tags have changed, except for the `name` tag, any tags that end with `time`, and any previous tags with value containing `Xloggc`. The pattern `*Xloggc*` would ignore changes such as:

``` java
{inputarguments_19='-Xloggc:/home/axibase/axibase-collector/logs/gc_29286.log'-> '-Xloggc:/home/axibase/axibase-collector/logs/gc_13091.log'}
```
