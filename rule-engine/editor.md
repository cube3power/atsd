# Rule Editor


## Overview

![](images/rule-editor.png)

## Settings

| **Setting** | **Description** |
| --- | --- |
| Enabled | Is the rule active or not. |
| Name | Rule names must be unique. Multiple rules can be created for the same metric. Rule names cannot be modified once a rule is created, so it's advisable to establish a naming convention. For example `{metric}.{condition}.{application/service}` and `cpu_busy.high.ERP-production`. |
| Last Update | Date and time when the rule was last modified. |
| Author | Optional user identifier to facilitate controlled changes in multi-user environments. |
| Description | Description of the rule. |
| Schedule | One or multiple cron expressions to control when the rule is active. The rule is active by default if no cron expressions are defined. The schedule is evaluated based on local server time. Multiple cron expressions can be combined using `AND` and `OR` operators and each expression must be enclosed within single quotes. Cron fields are specified in the following order: minute, hour, day-of-month, month, day-of-week. Examples: `* 8-18 * * MON-FRI` (Active between 08:00 and 18:59 on workdays) `* 0-7,19-23 * * MON-FRI` OR `* * * * SUN,SAT` (Active on weekends and non-working hours). |
| Disable Entity Grouping | Incoming data samples are grouped by entity (and by tags for multi-tag metrics), and therefore the expressions are evaluated for each entity/tag combination separately. If Entity Grouping is disabled, data samples are accumulated into a single window. This is typically useful for controlling data flow by raising an alert if the window is empty, `count() < 0`, for all entities collecting this metric. |
| Leaving Events | This setting applies to time-based windows. The rule expression is re-evaluated whenever a new sample enters the window. If the data flow is irregular or if samples stop coming in, it may cause the window to become stale by not evaluating the expression for the remaining samples. If 'Leaving Events' is enabled, the expression is evaluated twice for each sample: when it enters the window and when it exits the window. This causes increased load on the server and is not recommended for high-frequency metrics with regular and reliable data flow. |
| Metric | Enter metric name from the auto-complete drop-down. For alerting on messages, enter 'message' as the metric name. |
| Tags | Comma separated list of tags for grouping windows by each tag in addition to entities. Required for metrics that collect tagged data, for example the `df.disk_used` metric that collects data for multiple `file_systems` each identified with `file_system` and `disk_name tags`. |
| Window | Two types of windows are supported: count (length) and time (duration). The count-based window contains up to N (length) samples. When the count-based window becomes full, the oldest sample is replaced with a newly arrived sample. The time-based window contains all samples (regardless of how many) inserted within the specified period of time (duration). As time goes on, the time-based window automatically removes samples that become outside of the time interval. Aggregate functions applied to windows are equivalent to moving averages. For example, the `avg()` function for the `count(10)` window returns an average value for the 10 most recent samples. |
| Minimum Interval | Interval between the first and last samples in the window. If a Minimum Interval is set, the expression evaluates to false until there is enough data in the window. This condition is useful for time-based windows to prevent alerts for a database restart or whenever there is a restart of the data flow process. |
| Expression | Expression is a condition which is evaluated each time a data sample is received by the window. For example, the expression `value > 50` checks if a received value is greater than 50. If the expression evaluates to `true`, it raises an alert, followed by an execution of triggers such as a system command or email notification. Once the expression returns 'false', the alert is closed and another set of triggers is invoked. The expression consists of one or multiple checks combined with `OR` and `AND` operators. Exceptions specified in the Thresholds table take precedence over expressions. [Learn more about Expressions here.](expression.md) |
| Variables | List of custom fields with aliases which can be be accessed in placeholders by assigned name. |

