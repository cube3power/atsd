# Properties: Type Query

## Description

Returns an array of property types for the entity.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/properties/{entity}/types` |

### Parameters

| **Name** | **In** | **Description** |
|:---|:---|:---|
| `entity` | path | **[Required]** Entity name. |

## Response

An array of property type names.

### Fields

| **Field** | **Description** |
|:---|:---|
| `type` | Property type name. |

### Errors

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/properties/nurswgvml007/types
```

#### curl

```elm
curl  https://atsd_hostname:8443/api/v1/properties/nurswgvml007/types \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
[
    "disk",
    "system",
    "nmon.process"
]
```