# Scheduled Exporting

Scheduled exporting enables exporting of historical data and forecasts to the local file system in CSV or Excel formats, as well as delivery of produced reports to email subscribers.

## Scheduled Exporting Settings

### Schedule

| Field | Description |
| --- | --- |
|  Enabled  |  Enable the current scheduled export job.  |
|  Schedule  |  Cron expression specifying when the export job will be executed.<br>Field order: `seconds minutes hours day-of-month month day-of-week year`.<br>By default all export jobs are executed daily at 02:00 AM local server time: `0 0 2 * * *`.  |

### Schedule Syntax Examples

| Schedule | Expression |
| --- | --- |
|  Every 15 minutes  |  `0 0/15 * * * *`  |
|  Every hour  |  `0 0 * * * *`  |
|  Every 4 hours  |  `0 0 0/4 * * *`  |
|  Once per day at 02:00 server time  |  `0 0 2 * * *`  |
|  Every Monday at 02:00 server time  |  `0 0 2 * * MON`  |
|  First day of each month at 02:00 server time  |  `0 0 2 1 * *`  |

Concurrent execution for the same job is not allowed.

Export job settings in the server.properties file:

* `export.worker.count (default = 8)` – number of export jobs that can be executed at the same time
* `export.worker.queue (default = 8)` – number of export jobs that can be queued for execution

If new jobs are added for executing when the queue is full, such jobs will be rejected.

### Export Job Logging

Each export job execution is logged in ATSD. Messages are saved to track the status. Below are their parameters.

The administrator can create rules to be informed if jobs are not executed according to schedule.

`entity= atsd`
common tags: `type=application`, `source=atsd_export`, `hostname={HOST}`

|  | Status | Severity | Name | Message | Start Time | End Time |
| --- | --- | --- | --- | --- | --- | --- |
|  on job start  |  `status=started`  |  `severity=INFO`  |  `name={job_name}`  |  `message=Job started`  |  `start_time={start_time_iso}`  |  |
|  on job complete  |  `status=complete`  |  `severity=INFO`  |  `name={job_name}`  |  `message=Job completed`  |  `start_time={start_time_iso}`  |  `end_time={start_time_iso}`  |
|  on job queued  |  `status=queued`  |  `severity=WARN`  |  `name={job_name}`  |  `message=Job queued`  |  `start_time={start_time_iso}`  |  |
|  on job blocked *  |  `status=blocked`  |  `severity=ERROR`  |  `name={job_name}`  |  `message=Job blocked`  |  `start_time={start_time_iso}`  |  |
|  on job rejected  |  `status=rejected`  |  `severity=ERROR`  |  `name={job_name}`  |  `message=Job rejected`  |  `start_time={start_time_iso}`  |  |
|  on job failed  |  `status=failed`  |  `severity=ERROR`  |  `name={job_name}`  |  `message=Job failed`  |  `start_time={start_time_iso}`  |  `end_time={start_time_iso}`  |

> * Raised when the job starts while the previous instance of the same job is still running.

### Dataset

| Field | Description |
| --- | --- |
|  Name  |  Export job name.  |
|  Data Type  |  Type of data that will be exported.<br>Possible values: history, forecast.  |
|  Metric  |  Metric name for which data will be exported. Data can be exported for one metric at a time.  |
|  Entity  |  If selected, exported data will be limited to the specified entity. Supersedes the Entity Group selector.  |
|  Entity Group  |  If selected, exported data will be limited to entities contained in the specified entity group. Supersedes Entity Expression field.  |
|  Entity Expression  |  An expression to filter selected data by entity name and entity tags. For example: `name like 'nur*' AND tags.environment = 'prod'`  |
|  Value Filter  |  Expression to fetch only detailed samples that satisfy a condition. For example, `value != 0`. Value Filter is applied before aggregation and therefore impacts aggregated statistics values. To filter deleted values, use the `Double.isNaN(value)` syntax.  |
|  Selection Interval  |  Time frame of exported data. End of the Selection Interval can be optionally specified in End Time field, otherwise it is set to current time. Selection Interval setting is ignored if both Start Time and End Time fields are set.  |
|  Start Time  |  Start time of the selection interval. This field supports [calendar](../shared/calendar.md) keywords, for example 'previous_day'. If Start Time is not defined, it is set to End Time minus Selection Interval.  |
|  End Time  |  End time of the selection interval. This field supports [calendar](../shared/calendar.md) keywords, for example 'next_day'. If End Time is not defined, it is set to Start Time plus Selection Interval. If Start Time is not defined, End Time is set to current time.  |
|  Versioning  |  Display value history for metric that is enabled for Versioning. Versioning is displayed only for detailed, non-aggregated, samples.  |
|  Revisions Only  |  Filters displayed versions only for samples with values changes. Excludes samples without versions.  |
|  Version Filter  |  Expression to filter value history (versions) by version status, source, or time. For example: `version_status = 'Deleted' or version_source LIKE '*user*'`. To filter by version time, use the `date()` function. For example, `version_time > date('2015-08-11T16:00:00Z') or version_time > date('current_day')`. The `date()` function accepts [calendar](../shared/calendar.md) keywords.  |
|  Aggregate  |  Enable period aggregations based on selected detailed samples, after the optional Value Filter is applied.  |
|  Aggregation Period  |  Period of time over which detailed samples are aggregated.  |
|  Interpolation  |  Insert missing periods in aggregated results. The period is considered missing if it contains no detailed samples. Supported options: `STEP` – value of missing period equals value of the previous period; `LINEAR` – value is linearly interpolated between previous and next available value; `NONE` – missing periods are not inserted.  |
|  Aggregate Statistics  |  One or multiple aggregation functions: average, minimum, maximum, sum, count, standard deviation, weighted average, weighted time average, median (percentile 50), first, last, percentile 50/75/90/95/99/99.5/99.9, `MinValueTime`, `MaxValueTime`.  |

### Output

| Field | Description |
| --- | --- |
|  Format  |  Export file format.<br>Possible values: CSV, XLSX.  |
|  Compression  |  Compression of exported files.<br>Possible values: none, gzip, zip.  |
|  Output Path  |  Absolute path for exported files.<br>Expressions can be used to create timestamped files.<br>For example: `/tmp/daily/${yyyy-MM-dd}.csv`.<br>An expression like `/tmp/daily/${yyyy/MM/dd}.csv` creates the following directory `/tmp/daily/2015/08/02.csv`.<br>This means that exported files will be grouped by month and year, each in their relevant directory.<br>Supported placeholders: `${ENTITY}, ${ENTITY.tagName}, ${METRIC}, ${METRIC.tagName}, ${yyyy-MM-dd}, ${yyyy/MM/dd}`.  |
|  Split by Entity  |  Will create a new file for each exported entity, which is useful when exporting data for multiple entities.<br>If Output Path contains `${ENTITY}`, then for each entity the name will be substituted.<br>If Output Path does not contain `${ENTITY}`, then the entity name will be added to the end of the file name.<br>For example: `daily2015-07-31-nurswgsvl007.csv`.  |
|  Annotation  |  Custom annotation that will be added above the exported time series.<br>Can include any text, characters, and numbers.<br>If the field is left empty, no custom annotation will be added.<br>To include entity name, entity tags, metric names, or metric tags use the following placeholders as part of the annotation text:<br>`${ENTITY}`<br>`${ENTITY.tag1}`<br>`${METRIC}`<br>`${METRIC.tag2}`  |
|  Entity Tags  |  List of entity tags that will be included as columns in the exported file.  |
|  Metric Tags  |  List of metric tags that will be included as columns in the exported file.  |
|  Decimal Precision  |  Number of fractional digits displayed. If a negative value such as -1 is specified, stored numbers are displayed 'as is' without any formatting.  |
|  Time Format  |  Format for displaying series sample timestamps: Local Time (server time zone) or ISO (UTC time).<br>Local = `yyyy-MM-dd HH:mm:ss`<br>ISO = `yyyy-MM-dd'T'HH:mm:ss'Z'`  |

### Distribution

| Field | Description |
| --- | --- |
|  Email Subscribers  |  List of email addresses separated by commas, white spaces, or semicolons, to which the exported files will be sent as attachments.  |
|  Email Subject  |  Subject of email.<br>Supports placeholders: `${ENTITY}, ${ENTITY.tagName}, ${METRIC}, ${METRIC.tagName}, ${yyyy-MM-dd}`.  |

Clicking on the [TEST] button will export the first file, display the file name, and provide a link to download the file.

![](./images/export_job_test_button.png)
