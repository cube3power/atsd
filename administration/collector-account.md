# Collector Account

We recommend creating a dedicated `collector` user account with permissions limited to data collection tasks.

This account can be used in all clients sending data into ATSD using Data and Meta API.

![Collector Account](images/collector-account.png)

## Create `collectors` User Group

* Login into ATSD as administrator
* Open the **Settings > Users > User Groups > Create** page
* Create the `collectors` group with **[All Entities] Write** permission

![collectors group](images/all-entities-write.png)

## Create `collector` User

* Open the **Settings > Users > Create** page
* Create a `collector` user with **API_DATA_WRITE** and **API_META_WRITE** roles
* Check the `collectors` row in the User Groups table to add the user to the `collectors` group

![collector user](images/collector-user.png)
