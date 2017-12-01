# Mattermost Notifications

## Overview

The `MATTERMOST` [notification](../web-notifications.md) allows sending alert messages, alert detail tables, and charts into Mattermost channels. The integration is based on the [Mattermost API v4.0.0](https://api.mattermost.com/).

## Prerequisites

* Install and configure the [Web Driver](web-driver.md) in order to enable sending chart screenshots into Mattermost.

## Create Team

If necessary, create new team.
 
 * Click on **Main Menu**.
 * Click on **Create a New Team**.
 
    ![](images/create_new_team.png)
 
 * Fill in the **Team Name** filed, click **Next**.
 
    ![](images/mattermost_team_name.png)
    
 * Paste **Team URL**, click **Finish**.
 
    ![](images/team_url.png)
 
## Create Channel

* Click on **Create new private channel**.

    ![](images/mattermost_private_channel.png)
    
* Fill in the **Name** field, click **Create New Channel**.

    ![](images/mattermost_private_channel_name.png)
    
## Create Bot User

* Enable personal access tokens:

    * go to **Main Menu > System Console > Integrations > Custom Integration**
    * check (enable) **true** at **Enable Personal Access Tokens** property, click **Save**
 
        ![](images/enable_personal_tokens.png)

* Switch back to team.

    ![](images/mattermost_back_to_team.png)

* Get Team invite link:

    * go to **Main Menu > Get Team Invite Link**

       ![](images/team_invite.png)
       
    * copy the link, click **Close**
    
        ![](images/copy_link.png)
           
* Log out.

    ![](images/logout.png)
    
* Go to invite link.
* Fill in the registration's fields, click on **Create Account**.

    ![](images/bot_register.png)

* Log out.

## Enable Access Tokens

* Log in as team administrator.
* Go to **Main Menu > System Console > Users**.
* Click on **Member** drop-down according to bot user, select **Manage Roles**.

    ![](images/manage_roles.png)
    
* Check (enable) **Allow this account to generate personal access tokens**.
* Check (enable) **post:all**, click **Save**.

    ![](images/allow_tokens.png)

* Switch back to team.
* Go to created channel, click on **Invite others to this private channel**.

    ![](images/select_bot.png)  

* Select bot user, click **Add**.
* Log out.

## Generate Token

* Log in as bot user.
* Go to **Main Menu > Account Settings > Security > Personal Access Tokens**.

    ![](images/mattermost_generate_token_1.png)
    
    ![](images/mattermost_generate_token_2.png)  

* Click on **Create New Token**.
* Fill in the **Token Description** field, click **Save**.

    ![](images/token_descripton.png) 
    
* Copy the access token for future reference.

    ![](images/access_token.png)
    
* Close **Account Settings** window.

## Get Channel Id

* Click on channel for notifications from ATSD.
* Click on drop-down near the channel's header.
* Click on **View Info**.

    ![](images/view_channel_info.png)
    
* Copy the **ID** for future reference.

    ![](images/mattermost_channel_id.png)
    
## Create Mattermost Notification in ATSD

* Open the **Alerts > Web Notifications** page.
* Click on an existing `MATTERMOST` template, or click the **Create** button and switch the type to `MATTERMOST`.
* Copy the channel `ID` from the Mattermost client into the `Channel Id` field in the configuration form. 
* Copy the `Access Token` from the Mattermost client into the `Access Token` field in the configuration form. 

    ![](images/mattermost_settings.png)

* Click **Test**.

   ![](images/mattermost_hello_from_atsd.png)

* Select **Test Portal** to test the screenshot.

   ![](images/new_test_portal.png)   

* Click **Send Screenshot**.

   ![](images/mattermost_send_screenshot.png)
   
* If tests are OK, set the status **Enabled** and click **Save**.  

## Notification Parameters

|**Parameter**|**Description**|
|---|---|
|Channel Id||
|Access Token||
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
* Select Mattermost from the **Endpoint** drop-down.
* Enable the `OPEN`, `REPEAT`, and `CANCEL` triggers.
* Customize the alert message using [placeholders](../placeholders.md) as necessary, for example:

```ls
    OPEN = [${status}] ${rule} for ${entity} ${tags}. ${ruleLink}
    REPEAT = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
    CANCEL = [${status}] ${rule} for ${entity} ${tags}. Duration: ${alert_duration_interval}. ${ruleLink}
```

* Save the rule by clicking on the **Save** button.

    ![](images/mattermost_notification.png)
    
* The rule will create new windows based on incoming data. It may take a few seconds for the first commands to arrive and to trigger the notifications. You can open and refresh the **Alerts > Open Alerts** page to verify that an alert is open for your rule.

## Example

   ![](images/mattermost_test_1.png)

   ![](images/mattermost_test_2.png)
