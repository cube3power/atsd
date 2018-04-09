Monthly Change Log: March 2018
==================================================

## ATSD

**Issue**| **Category**    | **Type**    | **Subject**              
-----|-------------|---------|----------------------
5170 | forecast | Bug | NPE in forecast settings.
5169 | export | Bug | Scheduled Query: Tmp files not deleted if Store enabled and no other output specified.
5165 | entity_views | Bug | Grouping column error if view is empty.
5164 | log_aggregator | Bug | Replace sun.misc.BASE64Encoder.
5161 | export | Bug | Refer to portal by name instead of ID for entity groups.
5159 | sql | Feature | Add name, author and description placeholders in scheduled SQL queries.
5155 | export | Bug | Scheduled Query: NPE on commands store.
5153 | rule engine | Bug | Rule Engine: Generic type is not resolved for TagsMap.
5151 | core | Feature | Add User-Agent header in outgoing http requests.
5150 | sql | Feature | Implement short ISO formats for datetime literal.
5146 | security | Bug | Rename built-in collector groups.
5144 | rule engine | Bug | entity_label function.
5142 | rule editor | Bug | Check placeholder syntax for validity on save.
5139 | sql | Bug | SQL: Сolumn name sensitivity in subqueries.
5132 | security | Bug | Disable collector account creation without admin rights.
5130 | entity_views | Bug | Import doesn't display warnings if group is not found.
5128 | security | Feature | Add page for password obfuscation.
5127 | security | Bug | NPE in account exist checks.
5125 | UI | Feature | Webhook Request Page: view payload, parameters and headers.
5124 | rule editor | Bug | Fix slow rendering if the rule has web notifications.
5122 | security | Feature | Add wizards for creating collector and webhook users.
5120 | api-rest | Feature | Webhook API: auto-subscribe to AWS notifications.
5117 | rule engine | Bug | db_message functions: do not throw an exception if type or source not found.
5116 | rule engine | Bug | db_message_count function returns different results.
5115 | rule engine | Feature | rule_window fields.
5113 | security | Bug | New user group is allowed to view all portals by default.
5107 | sql | Feature | Join using subqueries - support for ON condition.
5105 | entity_views | Bug | Do not display column value if related entity tag value is not set.
5104 | sql | Feature | Scheduled report error on missing raw data.
5103 | monitoring | Bug | Simon console doesn't.
5098 | sql | Bug | Fix NPE in outer join with extra tag in one of the subqueries.
5096 | sql | Bug | Fix NPE in outer join.
5093 | rule engine | Bug | Resolve generic type parameter of returned collections.
5090 | rule engine | Bug | Access to collection objects.
5081 | UI | Bug | Selected entity group is not remembered.
5078 | installation | Bug | Installation: apply nohup to default startup scripts.
5070 | sql | Feature | Inline queries: remove time/datetime column requirement.
5067 | rule engine | Bug | getEntityLink function raises NPE on empty entity.
5066 | rule engine | Bug | AWS API: Fix test mode for configuration.
5065 | rule engine | Feature | Web Notifications: Add type, toggle fields.
5063 | export | Bug | Tag filter with wildcard allows any tag values.
5055 | csv | Bug | Incorrect version fields are stored from uploaded .csv file.
5051 | export | Bug | Scheduled Query: Output Path collision.
5049 | api-rest | Bug | Data API: slow search by property in entityExpression.
5036 | admin | Feature | Backup multiple record types from zip/tar.gz archive.
5018 | rule engine | Bug | Web Notifications: raw url presence breaks markdown format in Telegram.
5012 | entity_views | Bug | 'Entity Tag' link not applied to 'Entity Tag' column.
5001 | rule engine | Feature | Telegram: getUpdates message retriever as an alternative to webhook.
4957 | sql | Bug | Period query now takes long time to execute.
4925 | rule engine | Feature | Rule Engine: rule_window function.
4909 | security | Support | Install DV SSL certificate from Lets Encrypt CA.
4667 | export | Bug | Incorrect export of versioned values.
2158 | rule engine | Feature | Load historical data on window start.

## Collector

**Issue**| **Category**    | **Type**    | **Subject**             
-----|-------------|---------|----------------------
5141 | jdbc | Support | Timestamp format error in JDBC job.
5140 | UI | Bug | Empty page on opening simon console.
5114 | core | Bug | Collector CPU is abnormally high.
5099 | aws | Bug | Entity create error.
5089 | UI | Bug | Add 'Execution Time' column to job list.
5084 | aws | Bug | Job without pool is hanging.
5079 | json | Bug | Not all commands arrive in ATSD.
5074 | aws | Bug | Cloud front metrics not collected.
5071 | aws | Bug | 403 error caused by pagination.
5069 | jmx | Bug | Non-existing attributes in log.
5062 | aws | Bug | AWS region issues.
5056 | docker | Feature | Extract Apache Mesos container labels.
