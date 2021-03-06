# Series Query: Multiple Queries

## Description

Retrieve data for multiple series queries with different metrics, entities, and timespans.

Each query may return multiple series. The order of series in the response is arbitrary.

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "2016-02-22T13:30:00Z",
        "endDate":   "2016-02-22T13:31:00Z",
        "entity": "nurswgvml007",
        "metric": "cpu_busy"
    },
    {
        "startDate": "now - 1 * MINUTE",
        "endDate":   "now",
        "entity": "nurswgvml006",
        "metric": "memfree"
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml006",
    "metric": "memfree",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-06-27T14:37:13.000Z",
        "v": 74364
      },
      {
        "d": "2016-06-27T14:37:28.000Z",
        "v": 73008
      },
      {
        "d": "2016-06-27T14:37:44.000Z",
        "v": 75412
      },
      {
        "d": "2016-06-27T14:37:59.000Z",
        "v": 71636
      }
    ]
  },
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
        "d": "2016-02-22T13:30:08.000Z",
        "v": 4
      },
      {
        "d": "2016-02-22T13:30:24.000Z",
        "v": 3.03
      },
      {
        "d": "2016-02-22T13:30:40.000Z",
        "v": 6.06
      },
      {
        "d": "2016-02-22T13:30:56.000Z",
        "v": 4
      }
    ]
  }
]
```
