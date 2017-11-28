# Webhook

## Overview

The **webhook** [notification](../web-notifications.md) provides a simple way to send a pre-defined payload containing all window fields to an external HTTP service. The subscribing service is responsible for parsing, handling, and reacting to the received content.

## Method

The payload is sent using the `POST` method.

## Content Types

You can choose to send the payload as a `JSON` document or an html form.

* `application/json`
* `application/x-www-form-urlencoded`

## Headers

The request will include the standard HTTP headers such as Content-Length, Content-Type, User-Agent etc.

In addition, the request may include special header `X-Axi-Signature`, if the `Secret` field is configured.

This header contains the lower-cased `HMAC-SHA1` hex digest of the payload, signed with the `Secret`.

```
X-Axi-Signature: sha1=232c3cd1dedf9f5a5ac42bf63275b8b686ae53b6
```

In case of `application/x-www-form-urlencoded` content type, the hash is built for a message prepared by sorting request parameters by name, URL-encoding both parameter names and values, and then concatenating the sorted list of `name=value` pairs into a string using ampersand `&` character as a separator.

## Payload

The payload includes all fields that are relevant to the alert, including entity and metric metadata. Some of the fields will be empty.

Sample payload:

```json
  {
    "alert_duration": "00:00:00:00",
    "alert_duration_interval": "",
    "alert_message": "Alert Message for Testing",
    "alert_open_datetime": "2017-11-28T09:33:49Z",
    "alert_open_time": "2017-11-28 09:33:49 GMT",
    "alert_type": "OPEN",
    "avg": "21.5",
    "count": "2",
    "diff": "41.0",
    "entity": "test",
    "entity.timeZone": "Europe/Berlin",
    "event_datetime": "2017-11-28T09:33:49Z",
    "event_time": "2017-11-28 09:33:49 GMT",
    "expression": "value > 0",
    "first": "1.0",
    "intercept": "-6.198635453E7",
    "last": "42.0",
    "max": "42.0",
    "message": "",
    "metric": "test",
    "metric.label": "Test Metric",
    "metric.maxValue": "100",
    "metric.minValue": "0",
    "min": "1.0",
    "min_interval_expired": "",
    "open_value": "42",
    "percentile_50": "21.5",
    "percentile_75": "42.0",
    "percentile_90": "42.0",
    "percentile_95": "42.0",
    "percentile_99": "42.0",
    "properties": "",
    "received_datetime": "2017-11-28T09:33:49Z",
    "received_time": "2017-11-28 09:33:49.702 GMT",
    "repeat_count": "0",
    "repeat_interval": "",
    "rule": "Test Rule",
    "rule_expression": "value > 0",
    "rule_filter": "",
    "rule_name": "Test Rule",
    "schedule": "",
    "severity": "normal",
    "slope": "4.1E-5",
    "status": "OPEN",
    "stddev": "29.0",
    "sum": "43.0",
    "tags.name": "test",
    "value": "42",
    "variance": "840.5",
    "wavg": "28.3",
    "window": "length(2)",
    "window_first_datetime": "2017-11-28T09:45:30Z",
    "window_first_time": "2017-11-28 09:45:30 GMT",
    "wtavg": "42.0"
  }
```
