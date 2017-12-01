# HipChat Notifications

## Overview

The `HIPCHAT` [notification](../web-notifications.md) allows sending alert messages, alert detail tables, and charts into HipChat channels. The integration is based on the [HipChat API v2](https://www.hipchat.com/docs/apiv2).

## Prerequisites

* Install and configure the [Web Driver](web-driver.md) in order to enable sending chart screenshots into HipChat.

> To make requests over HTTPS you need to generate ssl self-signed certificate and copy it to ATSD server 

## Create Bot

* Log in to HipChat as admin.
* Click **System**.

    ![](images/system.png)

* Go to **Team Info**.
* Navigate to invite URL, click **Enable**.

    ![](images/invite_url.png)

* Copy the link.
* Sign out (right upper corner).

    ![](images/sign_out.png)

* Paste link to browser, press **Enter**.
* Fill in the fields, click **Sign Up**.

    ![](images/hipchat_atsd_bot.png)
    
## Generate Tokens

* Click on bot icon (right upper corner).

    ![](images/bot_icon.png)
    
* Click **Profile**.
* Go to **API tokens**.

> Make sure you are using API v2: there should be no warnings

* Select **Send Message** from the **Scopes** field.
* Fill in the **Label** filed.
* Click **Create**.

    ![](images/token.png)
    
* Repeat for **Send Notification** scope.

    ![](images/tokens.png)
    
* Copy the tokens for future reference.
* Log out.

## Create Room

* Log in to HipChat as admin.
* Click **Start chatting**.
* Click **Create a room**.
    
    ![](images/create_room.png)
    
* Fill in the fields, check (enable) **Private room**, click **Create room**.

    ![](images/private_room.png)
    
* Enter members to receive notifications from ATSD (you can do it later), enter bot user, click **Invite people**.

    ![](images/invite_bot.png)

## Get Room Id

* Click on team name
    
    ![](images/team_name.png)
    
* Click on recently created room
    
    ![](images/created_room.png)
    
* Look at URL, last number is the room id
    
    ![](images/room_url.png) 
    
## Create HipChat Notification in ATSD

* Open the **Alerts > Web Notifications** page.
* Click on an existing `HIPCHAT` template, or click the **Create** button and switch the type to `HIPCHAT`.
* Copy the `Message Token` from the HipChat client into the `Message Token` field in the configuration form. 
* Copy the `Notification Token` from the HipChat client into the `Notification Token` field in the configuration form. 
* Copy the `Room Id` from the HipChat client into the `Room Id` field in the configuration form. 

    ![](images/hipchat_settings.png)

* Click **Test**.

   ![](images/hipchat_hello_from_atsd.png)

* Select **Test Portal** to test the screenshot.

   ![](images/new_test_portal.png)   

* Click **Send Screenshot**.

   ![](images/hipchat_send_screenshot.png)
   
* If tests are OK, set the status **Enabled** and click **Save**.  

## Notification Parameters

|**Parameter**|**Description**|
|---|---|
|Room Id||
|Message Token||
|Notification Token||
|Bot Username|Overwrite your bot's user name.|
|Message Format||
|Message|Message text to be sent. This field should be left blank so it can be customized in the rule editor.|

## Testing Notification

### Create/import rule

* Create a new rule or import an existing rule for a built-in metric as described below.
* Download the file [rules.xml](resources/rules.xml).
* Open the **Alerts > Rules > Import** page.
* Check (enable) **Auto-enable New Rules**, attach the `rules.xml` file, click **Import**.

### Configure notification

* Open **Alerts > Rules** page and select a rule.
* Open the **Web Notifications** tab.
* Select HipChat from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT`, and `CANCEL` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
    OPEN = [${status}] ${rule} for ${entity} ${tags}. ${ruleLink}
    REPEAT = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
    CANCEL = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
```

* Save the rule by clicking on the **Save** button.

    ![](images/hipchat_notification.png)
    
* The rule will create new windows based on incoming data. It may take a few seconds for the first commands to arrive and to trigger the notifications. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

## Example

   ![](images/hipchat_test_1.png)

   ![](images/hipchat_test_2.png)


