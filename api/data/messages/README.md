# Data API: Messages Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](insert.md) | POST | `/api/v1/messages/insert` | `application/json` | Insert an array of messages. 
| [Webhook](webhook.md) | POST / GET | `/api/v1/messages/webhook/*` | `application/json` / none | Convert request to message and insert it.
| [Query](query.md) | POST | `/api/v1/messages/query` | `application/json` | Retrieve message records for the specified filters. |
| [Delete](delete.md) | - | - | - | Execute administrative actions to delete message records. |
| [Statistics Query](stats-query.md) | POST | `/api/v1/messages/stats/query` | `application/json` |  Retrieve message counters as series for the specified filters.  |
