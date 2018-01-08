# Math Functions

## Overview

The math functions perform basic numeric operations on the input number and return a number as the result.

## Reference

* [abs](#abs)
* [ceil](#ceil)
* [floor](#floor)
* [pow](#pow)
* [round](#round)
* [max](#max)
* [min](#min)
* [sqrt](#sqrt)
* [exp](#exp)
* [log](#log)

### `abs`

```javascript
  abs(double x) double
```

Returns the absolute value of `x`.

### `ceil`

```javascript
  ceil(double x) long
```

Returns the smallest integer that is greater than or equal `x`.

### `floor`

```javascript
  floor(double x) long
```

Returns the largest integer that is less than or equal `x`.

### `pow`

```javascript
  pow(double x, double y) double
```

Return `x` raised to the power of `y`.

### `round`

```javascript
  round(double x[, int y]) long
```

Returns `x` rounded to the `y` decimal places (precision). 

The precision is 0 if omitted.

`round(x, 0)` rounds the number to the nearest integer.

If `y` is less than 0, the number is rounded to the left of the decimal point.

### `max`

```javascript
  max(double x, double y) double
```

Returns the greater of two numbers: `x` and `y`.

### `min`

```javascript
  min(double x, double y) double
```

Returns the smallest of two numbers: `x` and `y`.

### `sqrt`

```javascript
  sqrt(double x) double
```

Returns the square root of `x`.

### `exp`

```javascript
  exp(double x) double
```

Returns `e` (2.71828183) raised to the power of `x`.

### `log`

```javascript
  log(double x) double
```

Base-`e` natural logarithm of `x`.





