# Operators

## Boolean Operators

| **Name** | **Description** |
| :--- | :--- |
| `OR` | Boolean OR, also `\|\|`. |
| `AND` | Boolean AND, also `&&`. |
| `NOT` | Boolean NOT, also `!`. |

```javascript
  value > 90 && avg() > 50
```

```javascript
  tags.file_system LIKE '/opt/*' OR tags.file_system LIKE '/mnt/*'
```

```javascript
  tags.file_system NOT LIKE '/dev/*'
```

```javascript
  NOT tags.isEmpty()
```

## Ternary Operator

| **Name** | **Description** |
| :--- | :--- |
| `?` | Ternary conditional |

The ternary `?` operator simplifies `if/else` syntax. The operator chooses one of the two options based on the boolean expression. 

If the expression `expr` evaluates to `true`, the operator selects `value1` option. Otherwise, `value2` is chosen.

```javascript
   boolean expr ? value1 : value2
```

Example:

```javascript
   tags.mount_point == '/' ? 90.0 : 75.0
```  

The above example is equivalent to:

```javascript
  if (tags.mount_point == '/') {
     return 90.0;
  } else {
     return 75.0;
  }
```

## Numeric Operators

| **Name** | **Description** |
| :--- | :--- |
| `+` | Plus. |
| `-` | Minus. |
| `*` | Multiply. |
| `/` | Divide. |
| `%` | Remainder. |
| `=` | Equal. Also `==`. |
| `!=` | Not equal. |
| `>` | Greater than. |
| `>=` | Greater than or equal. |
| `<` | Less than. |
| `<=` | Less than or equal. |
| `BETWEEN` | `n BETWEEN m AND p`.<br>The number `n` is between `m` and `p` (inclusive).<br>`m <= n <= p`.<br>Example: `avg() BETWEEN 10 and 20`. |
| `IN` | Returns `true` if the number is contained in the numeric [collection](functions-collection.md#in). |

```javascript
  value*100 > 90
```

```javascript
  max() BETWEEN 80 and 100
```

```javascript
  value IN (0, 1, 12)
```

## Text Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Also `==`. Equal. The comparison is case-**insensitive** ('a' = 'A' equals `true`).|
| `!=` | Not equal. The comparison is case-**insensitive** ('a' != 'A' equals `false`).|
| `BETWEEN` | Returns `true` if the left operand string is ordered between lower and upper strings on the right.<br>`a BETWEEN b AND c`.<br>String `a` is ordered between `b` and `c` (inclusive) using lexicographical comparison.<br>The comparison is case-**sensitive**.<br>Example: `timeStr BETWEEN '18:00' AND '18:04'`.|
| `LIKE` | Returns `true` if the left operand string matches the pattern on the right. The pattern may include regular characters and  wildcards `?` and `*`.|
| `IN` | Returns `true` if the left operand string is contained in the string [collection](functions-collection.md#in) specified in parenthesis on the right. |

```javascript
  entity = 'nurswgvml007'
```

```javascript
  entity LIKE '*007'
```		

```javascript
  entity IN ('nurswgvml007', 'nurswgvml010')
```
