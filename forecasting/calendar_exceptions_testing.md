# Forecast Tools

## Exceptions

The purpose of exceptions is to exclude specific intervals from the data selection interval. This is necessary when unusual data is recorded for the time series and this unusual data distorts the forecast. 

For example, a 12-hour 100% cpu_busy interval caused by a broken script. Even after the problem is fixed (script stopped), the abnormal data remains and will cause forecast to be inaccurate. Another example is a data gap, where collection stopped for a while, and this may impact the forecast accuracy. ATSD algorithms cannot automatically identify and discard abnormal records, and Exception is a manual solution for it.

![](resources/calendar_exceptions_testing_1.png) 

### Settings

| Setting | Description |
|---|---|
|Metric|Metric to which the exception applies.|
|Entity|Entity to which the exception applies.|
|Tags|Series tags.|
|Server Time|Current server time.|
|Start Time|Start time of the excluded interval.|
|End Time|End time of the excluded interval.|
|Reference|The short field to add meta-data about the excluded interval.|
|Description|The short field to add meta-data about the excluded interval.|

The reason Exceptions are stored separately from Forecast Settings is to have one Exception apply to multiple matching forecasts at the same time.

## Calendar

Calendars in comparison with Exceptions allow to exclude data related to Forecast to which them applied in Forecast Settings Editor. In addition, Calendars provide a more flexible date configuration.

![](resources/calendar_exceptions_testing_3.png) 

![](resources/calendar_exceptions_testing_2.png) 

### Settings

| Setting | Description |
|---|---|
|Start Working Hours|Start hour of the excluded interval: `HH:mm`.|
|End Working Hours|End hour of the excluded interval: `HH:mm`.|
|Dates|Day, month and year of the excluded interval: `dd-MMM` or `dd-MMM-yyyy`.|

## Testing

Testing allows to calculate forecasts based on data in the CSV file or in the text area. The database is not involved and the forecast is not saved. The first row in the CSV is ignored.

```ls
Timestamp,Value
2018-03-21 00:00:00,1
2018-03-22 00:00:00,2
2018-03-23 00:00:00,3
2018-03-24 00:00:00,4
2018-03-25 00:00:00,5
```
