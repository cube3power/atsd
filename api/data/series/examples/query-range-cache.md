# Series Query: Retrieve Last Value

## Description

Retrieves last value for each series from the Last Insert Cache table.

If the last value was received outside of the specified time range, no data is returned.

Queries for Last Insert Cache are efficient since the table contains only the last value and has fewer rows to scan.

Values in Last Insert Cache table maybe delayed up to 1 minute (cache to disk interval).

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "now - 5 * MINUTE",
    "endDate": "now",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "cache": true
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-06-27T18:48:47.000Z",
        "v": 4
      }
    ]
  }
]
```
