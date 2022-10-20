# IBM Cloud Classic VSI Power Actions

This VSI power action is using `IBM Cloud Code Engine` service to schedule the
power actions.

Upon the code execution in this repository will create `IBM Cloud Code Engine` project,
jobs and cron executions. These detail can be viewed/edited through UI/CLI after successful execution in `cloud.ibm.com`.

## Prerequisites

- Clone the repo <https://github.com/KumarGanesanIBM/ibmcloud-classic-vsi-power-action>

## Input to the script

Below are the input to the script. These inputs should be specified in `vsi_power_action.env` file.

- `IBMCLOUD_API_KEY` - IBM Cloud Account API Key for creating Code Engine Project.
- `IBMCLOUD_REGION` - IBM Cloud region where Code Engine should be created.
- `IBMCLOUD_RESOURCE_GROUP` - IBM Cloud Resource Group (if it default, then the input should be Default)
- `IBMCLOUD_PROJECT_NAME` - IBM Cloud Code Engine Project Name.
- `CLASSIC_VSI_ACCOUNT_API_KEY` - Classic VSI Account API Key.  This is the account where all the VSIs should be scheduled for power on/off.
- `CLASSIC_VSI_ACCOUNT_USER_NAME` - Classic VSI Account User name.
- `CLASSIC_VSI_LIST_FILE` - Classic VSI list file `vsi_id.txt`. This file should contain the list of VSI IDs which are needed to be scheduled for power on/off.

### Example for having the VSI IDs in the file

```text
VSI_1=133108695
VSI_2=133132083
```

- `POWER_ON_SCHEDULE` - Power ON Schedule (it should be in the format of Cron job schedule)
- `POWER_OFF_SCHEDULE` - Power OFF Schedule (it should be in the format of Cron job schedule)

## Script execution

Execute the file `vsi_power_action.sh`

```bash
sh vsi_power_action.sh
```
