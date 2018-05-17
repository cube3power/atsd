# Messages: Webhook

## Description

This method accepts `GET` and `POST` requests with optional JSON or form payload and converts the request into message fields. The produced message is stored in the database and processed in the rule engine.

A set of reserved parameter names, specified in the query string, instruct the server how to parse incoming requests. The reserved parameters determine mappings between the request content and message fields as well as define which data is discarded as extraneous.

This method can be used to ingest HTTP notifications from services that support outgoing webhooks such as GitHub, AWS SNS, Jenkins, Docker Hub, Slack/Telegram/Discord Bots etc.

## Reference

* [Request](#request)
* [Authentication](#authentication)
* [Authorization](#authorization)
* [Request Parameters](#request-parameters)
* [JSON Payload](#json-payload)
* [Entity Mapping](#entity-mapping)
* [Default Message Field Values](#default-message-field-values)
* [Reserved Request Parameters](#reserved-request-parameters)
  * [Literal Value Parameters](#literal-value-parameters)
  * [Command Parameters](#command-parameters)
  * [Header Parameters](#header-parameters)
  * [Filter Parameters](#filter-parameters)
  * [Parse Parameters](#parse-parameters)
  * [Control Parameters](#control-parameters)
* [Parameter Precedence](#parameter-precedence)
* [Sample URLs](#sample-urls)
* [Example](#example)
* [Diagnostics](#diagnostics)

## Request

| **Method** | **Path** | **Payload** | **Content-Type Header** |
|:---|:---|---|---:|
| POST | `/api/v1/messages/webhook/*` | JSON | `application/json` |
| POST | `/api/v1/messages/webhook/*` | `key=value` | `application/x-www-form-urlencoded` |
| GET | `/api/v1/messages/webhook/*` | None | - |

The URL may point to any path after `/webhook`, for example, `/api/v1/messages/webhook/service-1`.

## Authentication

Requests must be authenticated.

When initiating a request with an http client, user credentials are included in the request URL as follows:

```elm
https://user:password@atsd_hostname:8443/api/v1/messages/webhook/jenkins?entity=jen01
```

## Authorization

The user must have `API_DATA_WRITE` role and `write` permissions for the target entity.

### Webhook User Wizard

To create a new user with permissions to write data for a specific entity, open **Settings > Users** and select **Create Webhook User** from the split button located below the 'Users' table.

![](./images/webhook-user.png)

The wizard will automatically create user and entity groups and grant necessary permissions.

![](./images/webhook-permissions.png)

## Request Parameters

Request parameters, except for reserved parameters, are converted into message **tags** where tag names equal parameter names and tag values equal parameter values. Tag names are converted to lower case. Non-printable characters such as whitespace in tag names are replaced with an underscore.

Request URL:

`/api/v1/messages/webhook/incoming?entity=test-1&action=started&Repeat=1`

Message tags:

```ls
action=started
repeat=1
```

## JSON Payload

The JSON payload is parsed to locate numeric, string, and boolean fields which are added to the message as **tags**. The tag's name is set from the field's path, which is composed from the parent object's path, followed by dot `.` and the field's own name. Tag names are converted to lower case with non-printable characters such as whitespace replaced with an underscore.

Input document:

```json
{
  "event": "commit",
  "repository": {
    "name": "atsd",
    "public": true,
    "Full Name": "Axibase TSD",
    "references": [],
    "authors": ["john", "sam"]
  }
}
```

Message tags:

```ls
event = commit
repository.name = atsd
repository.public = true
repository.full_name = Axibase TSD
repository.authors[0] = john
repository.authors[1] = sam
```

String fields are unquoted by removing leading and trailing single or double quotes, if present.

Array elements are assigned names based on array name and element index, starting with `0` for the first element.

## Entity Mapping

Since each message must be associated with an entity, the request should instruct the server how to determine the entity name from the request parameters and the payload.

1. By default, the entity will be set to the remainder of the path following the `/api/v1/messages/webhook/` prefix.

    ```elm
      /api/v1/messages/webhook/jenkins?hello=world
    ```

    ```elm
      entity = jenkins
    ```

1. The entity may be specified literally by adding an `entity` parameter to the query string, for example `/api/v1/messages/webhook/jenkins?entity=test-1`

    ```elm
      entity = test-1
    ```

1. The entity can be extracted from a JSON field by referencing the field's full name with `command.entity` parameter, for example `/api/v1/messages/webhook/jenkins?command.entity=server.name`

    ```json
      {
        "server": {
          "name": "test-2",
          "site": "NUR"
        }
      }
    ```

    ```elm
      entity = test-2
    ```

1. The entity can be extracted from request headers by specifying the header name, for example `/api/v1/messages/webhook/jenkins?header.entity=X-AXI-Region`

    HTTP request headers:

    ```txt
      X-AXI-Region: us-east-01
    ```

    ```elm
      entity = us-east-01
    ```

## Default Message Field Values

* Message `type` is 'webhook'.
* Message `source` is set to the remainder of the URL path after the `/webhook/` part (and before the query string). If the remainder is empty, the `source` is set to empty string.

```ls
  source = incoming for /api/v1/messages/webhook/incoming?entity=test
  source =          for /api/v1/messages/webhook?entity=test
```

* Message `entity` is set to the remainder of the URL path after `/webhook/` (but before the query string). If the remainder is empty, the `entity` **must** be specified as described in the 'Entity Mapping' section above.
* Message `severity` is undefined.
* Message `date` is set to current server time.
* Message tag `request_ip` is set to the remote IP address of the http client that initiated the request.

## Reserved Request Parameters

### Literal Value Parameters

These parameters set message fields to literal values.

| **Name** | **Description** |
|---|---|
| `type` | Message type.|
| `source` | Message source. |
| `entity` | Message entity. |
| `date` | Message date and time in ISO format. |
| `message` | Message text. |
| `severity` | Message severity specified as an integer or as a string constant. |
| `datetimePattern` | Date pattern applied to `command.date` field: `iso` (default), `seconds`, `milliseconds`, user-defined [date pattern](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html). |

`/api/v1/messages/webhook/jenkins?entity=test-1&type=ci&severity=3`

```elm
  entity = test-1
  type = ci
  severity = WARNING
```

### Command Parameters

Command parameters set message field values from JSON field values.

| **Name** | **Description** |
|---|---|
| `command.type` | Message type.  |
| `command.source` | Message source.  |
| `command.entity` | Message entity.  |
| `command.date` | Message time in ISO format, UNIX milliseconds/seconds, or user-defined format specified with `datetimePattern` parameter. |
| `command.message` | Message text. |
| `command.severity` | Message severity specified as an integer or as a constant. |

`/api/v1/messages/webhook/jenkins?command.entity=server&command.type=event`

```json
  {
    "server": "test-2",
    "event": "deploy"
  }
```

```elm
  entity = test-2
  type = deploy
```

### Header Parameters

Header parameters set message field values from header values.

| **Name** | **Description** |
|---|---|
| `header.type` | Message type.  |
| `header.source` | Message source.  |
| `header.entity` | Message entity.  |
| `header.date` | Message date and time in ISO format. |
| `header.message` | Message text. |
| `header.tag.{name}` | Message tag. |
| `header.severity` | Message severity specified as an integer or as a constant. |

`/api/v1/messages/webhook/github?header.tag.event=X-GitHub-Event`

```json
  User-Agent: GitHub-Hookshot/5ee1da1
  X-GitHub-Delivery: 955bf180-e573-11e7-9438-56fe67d6b38d
  X-GitHub-Event: watch
  X-Hub-Signature: sha1=b0d4aa86d17c6b77e5b35e7482769955ad9aca4d
```

```elm
  entity = github
  tags.event = watch
```

### Filter Parameters

The filter parameters contain patterns that the converted message tags must satisfy in order to be included in the generated message command.

| **Name** | **Description** |
|---|---|
| `exclude` | Exclude tags with **names** that match the specified pattern. |
| `excludeValues` | Exclude tags with **values** that match the specified pattern. |
| `include` | Override `exclude` rules by including tags with **names** that match the specified pattern. |
| `includeValues` | Override `excludeValues` rules by including tags with **values** that match the specified pattern. |

* The patterns support `*` as a wildcard.
* Tag name match is case-**IN**sensitive.
* The parameters may contain multiple patterns separated by semi-colon `;`.

```elm
  &exclude=repository.*;sender.location
```

* Parameters may be repeated in the query string.

```elm
  &exclude=repository.*&exclude=sender.location
```

Example:

```elm
  &exclude=repository.*&include=repository.name
```

```json
{
  "event": "commit",
  "result": "ok",
  "repository": {
    "name": "atsd",
    "public": true,
    "Full Name": "Axibase TSD",
    "references": []
  }
}
```

  Message fields:

```elm
    tag.event = commit
    tag.result = ok
    tag.repository.name = atsd
```

### Parse Parameters

| **Name** | **Description** |
|---|---|
| `json.parse` | Name of the request parameter or a field in the JSON payload to be parsed as a JSON document and converted into message tags similar to the [JSON payload](#json-payload) itself.|

Examples:

* **Form content type**

`/api/v1/messages/webhook/travis-ci?json.parse=payload`

In this example the `payload` parameter contains a JSON string which is parsed into message tags using the `json.parse=payload` instruction.

```txt
  event=build&payload={"id":371662529,"number":"217","config":{"os":"linux"}}
```

Message tags:

```elm
  event=build
  payload.id=371662529
  payload.number=217
  payload.config.os=linux
```

* **JSON content type**

`/api/v1/messages/webhook/aws-cloudwatch?json.parse=Message`

The `Message` field in the JSON payload contains a string which is a JSON document itself. The `Message` field value is parsed and converted into message tags using the `json.parse=Message` instruction.

```json
{
  "Type": "Notification",
  "Message": "{\"version\":\"0\",\"source\":\"aws.ec2\",\"region\":\"us-east-1\"}"
}
```

Message tags:

```elm
  type=Notification
  message.version=0
  message.source=aws.ec2
  message.region=us-east-1
```

### Control Parameters

| **Name** | **Description** |
|---|---|
| `debug` | If set to `true`, the response includes the message record in JSON format.|

## Parameter Precedence

The reserved parameters have the following precedence:

1) Literal Value Parameters
2) Command Parameters
3) Header Parameters

Example:

* Request URL:

```elm
    /api/v1/messages/webhook/github?entity=test-1&header.entity=User-Agent&command.entity=server
```

* Request Headers:

```txt
    User-Agent: GitHub-Hookshot/5ee1da1
```

* Request Payload:

```json
    {
      "server": "test-2"
    }
```

* Message Command:

```elm
    type=github
    source=webhook
    entity=test-1
    tags:
        server=test-2
        request_ip=...
```

## Sample URLs

### GitHub

Subscribe to GitHub repository events.

```elm
/api/v1/messages/webhook/github?exclude=organization.*;repository.*;*.signature;*.payload;*.sha;*.ref;*_at;*.id&include=repository.name;repository.full_name&header.tag.event=X-GitHub-Event&excludeValues=http*&debug=true
```

### Amazon WS

Receive AWS SNS subscription notifications.

```elm
/api/v1/messages/webhook/aws-cw?command.date=Timestamp&json.parse=Message&exclude=Signature;SignatureVersion;SigningCertURL;SignatureVersion;UnsubscribeURL;MessageId;Message.detail.instance-id;Message.time;Message.id;Message.version
```

### Jenkins

Subscribe to build status events from Jenkins.

```elm
/api/v1/messages/webhook/jenkins?command.date=build.timestamp&datetimePattern=milliseconds&exclude=build.url;url;build.artifacts*
```

### Travis CI

Subscribe to build status events from Travis CI.

```sh
/api/v1/messages/webhook/travis-ci?json.parse=payload&exclude=payload.id;payload.number;payload.config*;payload.repository*;payload.matrix*;payload.*commit*;payload.status_message;payload.result&include=payload.repository.name&command.message=payload.result_message
```

### Slack

Receive incoming bot events using Slack Event API. Refer to the Slack webhook configuration [instructions](../../../rule-engine/notifications/outgoing-webhook-slack.md).

```elm
/api/v1/messages/webhook/slack?command.message=event.text&command.date=event.ts&exclude=event.event_ts&exclude=event_time&exclude=event.icons.image*&exclude=*thumb*&exclude=token&exclude=event_id&exclude=event.message.edited.ts&exclude=*.ts
```

### Telegram

Receive incoming bot messages. Refer to the Telegram webhook configuration [instructions](../../../rule-engine/notifications/outgoing-webhook-telegram.md).

```elm
/api/v1/messages/webhook/telegram?command.message=message.text
```

## Example

Request:

```elm
POST https://usr:pwd@atsd_hostname:8443/api/v1/messages/webhook/github?exclude=organization.*;repository.*;*.signature;*.payload;*.sha;*.ref;*_at;*.id&include=repository.name;repository.full_name&header.tag.event=X-GitHub-Event&excludeValues=http*&debug=true
```

Notes:

* Fields with name starting with `organization.` are excluded.
* Fields with name starting with `repository.` are excluded (except `repository.name`).
* Fields `repository.name` and `repository.full_name` are included.
* Fields with values starting with `http` are excluded.
* Tag `event` is retrieved from the `X-GitHub-Event` header.

Payload:

```json
{
  "action": "started",
  "repository": {
    "id": 54949530,
    "name": "atsd",
    "full_name": "axibase/atsd",
    "owner": {
      "login": "axibase",
      "id": 10971416,
      "avatar_url": "https://avatars0.githubusercontent.com/u/10971416?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/axibase",
      "html_url": "https://github.com/axibase",
      "followers_url": "https://api.github.com/users/axibase/followers",
      "following_url": "https://api.github.com/users/axibase/following{/other_user}",
      "gists_url": "https://api.github.com/users/axibase/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/axibase/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/axibase/subscriptions",
      "organizations_url": "https://api.github.com/users/axibase/orgs",
      "repos_url": "https://api.github.com/users/axibase/repos",
      "events_url": "https://api.github.com/users/axibase/events{/privacy}",
      "received_events_url": "https://api.github.com/users/axibase/received_events",
      "type": "Organization",
      "site_admin": false
    },
    "private": false,
    "html_url": "https://github.com/axibase/atsd",
    "description": "Axibase Time Series Database Documentation",
    "fork": false,
    "url": "https://api.github.com/repos/axibase/atsd",
    "forks_url": "https://api.github.com/repos/axibase/atsd/forks",
    "keys_url": "https://api.github.com/repos/axibase/atsd/keys{/key_id}",
    "created_at": "2016-03-29T05:51:34Z",
    "updated_at": "2017-12-22T13:32:50Z",
    "pushed_at": "2017-12-22T12:56:17Z",
    "git_url": "git://github.com/axibase/atsd.git",
    "ssh_url": "git@github.com:axibase/atsd.git",
    "clone_url": "https://github.com/axibase/atsd.git",
    "svn_url": "https://github.com/axibase/atsd",
    "homepage": "https://axibase.com/products/axibase-time-series-database/",
    "size": 78274,
    "stargazers_count": 37,
    "watchers_count": 37,
    "language": "HTML",
    "has_issues": true,
    "has_projects": false,
    "has_downloads": true,
    "has_wiki": false,
    "has_pages": true,
    "forks_count": 12,
    "mirror_url": null,
    "archived": false,
    "open_issues_count": 1,
    "license": null,
    "forks": 12,
    "open_issues": 1,
    "watchers": 37,
    "default_branch": "master"
  },
  "organization": {
    "login": "axibase",
    "id": 10971416,
    "url": "https://api.github.com/orgs/axibase",
    "repos_url": "https://api.github.com/orgs/axibase/repos",
    "events_url": "https://api.github.com/orgs/axibase/events",
    "hooks_url": "https://api.github.com/orgs/axibase/hooks",
    "issues_url": "https://api.github.com/orgs/axibase/issues",
    "members_url": "https://api.github.com/orgs/axibase/members{/member}",
    "public_members_url": "https://api.github.com/orgs/axibase/public_members{/member}",
    "avatar_url": "https://avatars0.githubusercontent.com/u/10971416?v=4",
    "description": "Public Axibase repositories on GitHub"
  },
  "sender": {
    "login": "rodionos",
    "id": 2098022,
    "avatar_url": "https://avatars3.githubusercontent.com/u/2098022?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/rodionos",
    "html_url": "https://github.com/rodionos",
    "followers_url": "https://api.github.com/users/rodionos/followers",
    "following_url": "https://api.github.com/users/rodionos/following{/other_user}",
    "gists_url": "https://api.github.com/users/rodionos/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/rodionos/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/rodionos/subscriptions",
    "organizations_url": "https://api.github.com/users/rodionos/orgs",
    "repos_url": "https://api.github.com/users/rodionos/repos",
    "events_url": "https://api.github.com/users/rodionos/events{/privacy}",
    "received_events_url": "https://api.github.com/users/rodionos/received_events",
    "type": "User",
    "site_admin": false
  }
}
```

Command:

```json
{
    "entity": "github",
    "type": "webhook",
    "source": "github",
    "severity": null,
    "tags": {
        "action": "started",
        "event": "watch",
        "repository.name": "atsd",
        "repository.full_name": "axibase/atsd",
        "request_ip": "192.30.253.29",
        "sender.id": "2098022",
        "sender.login": "rodionos",
        "sender.site_admin": "false",
        "sender.type": "User"
    },
    "date": "2017-12-22T13:32:50.901Z"
}
```

## Diagnostics

The last 100 recently received webhooks are listed on the **Settings > Diagnostics > Webhook Requests** page.

![](./images/webhooks.png)

![](./images/webhook-detail.png)
