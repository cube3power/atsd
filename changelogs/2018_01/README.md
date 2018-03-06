Monthly Change Log: January 2018
==================================================

## ATSD

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
4940 | rule engine | Feature | Add administrative [setting](../../rule-engine/window.md#cancel-status) to control On Cancel behavior.
4931 | rule engine | Bug | Zero time filter is not saved on rule XML export.
4929 | rule engine | Bug | Web notifications: Telegram discards long messages.
4926 | sql | Bug | SQL: Non-boolean datatype for conditions.
4923 | rule engine | Bug | Telegram `400` error doesn't contain information about the message.
4921 | security | Bug | Built-in user can't log in to take portal screenshot.
4920 | security | Bug | Disabled user is able to execute SQL queries.
4914 | rule engine | Bug | Add details to error messages in HipChat.
4913 | client | Feature | Upgrade R client to remove dependency on user home directory.
4911 | rule engine | Bug | Pass query into an SQL client containing `>` character.
4910 | rule engine | Bug | Implement [`executeSqlQuery`](../../rule-engine/functions-db.md#executesqlquery) function to retrieve SQL query results in rule conditions and notifications.
4908 | rule engine | Feature | Create rule from the message Search page.
4901 | rule engine | Feature | Implement [utility](../../rule-engine/functions-utility.md#utility-functions)  functions to parse URL fields.
4900 | rule engine | Feature | Implement [`getEntityName`](../../rule-engine/functions-lookup.md#getentityname) lookup function.
4899 | rule engine | Feature | Implement [`trim`](../../rule-engine/functions-text.md#trim) text function to remove leading and trailing non-printable characters.
4897 | rule engine | Feature | Implement [`getPropertyLink`](../../rule-engine/functions-link.md#getpropertylink) function for entity.
4896 | rule engine | Feature | Implement [`getPropertyTypes`](../../rule-engine/functions-property.md#getpropertytypes) function to return a list of property types for the entity.
4893 | UI | Feature | Statistics page: display tag names based on associated metric and entity tag templates.
4892 | rule engine | Feature | Extend [`excludeKeys`](../../rule-engine/functions-collection.md#excludekeys) function - add support for patterns.
4889 | rule engine | Bug | Round numbers in web notifications.
4888 | rule engine | Bug | Email subject should not include inline links.
4883 | rule engine | Bug | Window remains in `OPEN` status after all commands are removed.
4879 | rule engine | Feature | Add support for [control flow](../../rule-engine/control-flow.md) in notifications.
4877 | rule engine | Bug | `entity_tags` expression fails if used without key.
4875 | rule engine | Feature | Add date filter to rule list.
4874 | rule engine | Feature | Add variables table to email notification.
4873 | rule engine | Feature | Implement [entity lookup](../../rule-engine/functions-lookup.md#getentity) function.
4872 | rule engine | Feature | Implement [`property_map`](../../rule-engine/functions-property.md#reference) function.
4871 | rule engine | Feature | Implement [`addTable`](../../rule-engine/functions-format.md#reference) function.
4870 | rule engine | Feature | Implement [entity link](../../rule-engine/links.md#entitylink) placeholders.
4869 | rule engine | Bug | Print empty string instead of `null` if placeholder evaluates to `null`.
4868 | message | Bug | Webhook: change parameter and field [precedence](../../api/data/messages/webhook.md#parameter-precedence).
4867 | api-rest | Bug | Data API: First period is out of selection interval with `END_TIME` aggregation.
4866 | sql | Bug | Incorrect `GROUP BY MONTH` with non-CALENDAR alignment.
4865 | rule engine | Bug | The `milliseconds` function fails if input is `null`.
4864 | rule engine | Bug | Change behavior of [text](../../rule-engine/functions-text.md#keepafter) functions.
4863 | rule engine | Feature | Default value argument for [`lookup`](../../rule-engine/functions-lookup.md#lookup) function.
4861 | api-rest | Feature | Webhook: set [command time](../../api/data/messages/webhook.md#command-parameters) from (milli)seconds.
4858 | rule engine | Feature | Implement [`unquote`](../../rule-engine/functions-text.md#unquote) function.
4857 | rule engine | Bug | Delete open alerts when entity is deleted.
4856 | rule engine | Bug | Random function values are cached by subsequent invocations.
4854 | rule engine | Feature | Implement additional [math](../../rule-engine/functions-math.md#reference) functions.
4852 | rule engine | Bug | Rule window detail page shows incorrect results for windows with 'Property' data type.
4851 | rule engine | Feature | Implement [freemarker-style](../../rule-engine/functions-text.md#reference) text functions.
4849 | rule engine | Bug | Error in time format functions.
4848 | UI | Bug | Export page: FreeMarker error for forecast export.
4846 | rule engine | Feature | Web notifications: add status column.
4845 | forecast | Bug | Forecast settings: restored disappeared tooltips.
4833 | rule engine | Feature | Implement Web Notifications for [Microsoft Azure](../../rule-engine/notifications/azure-sb.md).
4832 | rule engine | Feature | Implement Web Notifications for [Google Cloud Platform](../../rule-engine/notifications/gcp-ps.md).
4826 | rule engine | Bug | API request hangs while rule is being processed.
4823 | rule editor | Feature | Rule Editor refactoring.
4822 | sql | Bug | Incorrect selection interval inference from filter conditions.
4821 | sql | Feature | Overlapping error for non-overlapping intervals.
4820 | api-rest | Bug | Series query with grouping - incorrect result of min_value_time aggregation.
4786 | entity | Feature | Tag Template: add a option to auto-generate a template from tags of the given entity.
4777 | api-rest | Bug | Series query: empty response instead of expected series (tag filters error).
4768 | api-rest | Bug | Series query: If query has series limit then unwanted empty series could occur in response.
4746 | api-rest | Feature | Add [`order`](../../api/data/series/rate.md#parameters) field to "rate" function.
4729 | api-rest | Bug | Series query: aggregate and group order and period.
4727 | jdbc | Bug | JDBC driver: FileNotFoundException on log4j.
4700 | sql | Bug | Incorrect `GROUP BY PERIOD` with `END_TIME` and `DST` change inside period.
4660 | statistics | Feature | DAO: calculate only requested statistics.
3573 | security | Feature | SSL: upgrade cypher protocols.
2870 | api-rest | Bug | REST API - authentication errors - check `403` status and json format in responses.
2709 | rule engine | Feature | Messages: one-click to create rule from message.
2086 | rule editor | Bug | Rule "Test" not working for messages.

## Collector

Issue| Category    | Type    | Subject              
-----|-------------|---------|----------------------
4928 | kafka | Bug | Exception in kafka job with `message format=API` command.
4924 | core | Bug | Disk usage is abnormal.
4895 | core | Bug | Delete temporary files.
