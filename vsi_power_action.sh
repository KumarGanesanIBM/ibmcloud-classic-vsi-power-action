#!/usr/bin/bash

# initializing input variables
. ./vsi_power_action.env

# login
ibmcloud login -a cloud.ibm.com -r "$IBMCLOUD_REGION" -g "$IBMCLOUD_RESOURCE_GROUP"

# delete project
ibmcloud ce project delete --hard --name "$IBMCLOUD_PROJECT_NAME"
status=$?
if [ $status -ne 0 ]; then
    echo "Project deletion failed with exit code $status !"
    echo "Coninuing any way!"
fi

# create project
ibmcloud ce project create -n "$IBMCLOUD_PROJECT_NAME"
status=$?
if [ $status -ne 0 ]; then
    echo "Project creation failed with exit code $status !"
    exit $status
fi

# select project
ibmcloud ce project select -n "$IBMCLOUD_PROJECT_NAME"
status=$?
if [ $status -ne 0 ]; then
    echo "Project selection failed with exit code $status !"
    exit $status
fi

# adding secrets
ibmcloud ce secret create --name api-key --from-literal "API_KEY=$CLASSIC_VSI_ACCOUNT_API_KEY"
ibmcloud ce secret create --name user-name --from-literal "USER_NAME=$CLASSIC_VSI_ACCOUNT_USER_NAME"

# adding config maps
ibmcloud ce configmap create --name vsi-power-action-on --from-literal "POWER_ACTION=on"
ibmcloud ce configmap create --name vsi-power-action-off --from-literal "POWER_ACTION=off"
ibmcloud ce configmap create --name vsi-id --from-env-file vsi_id.txt

# create power on job
ibmcloud ce job create --name vsi-power-action-on --build-source . --wait --cpu .125 \
    --memory .25G --env-from-secret api-key --env-from-secret user-name \
    --env-from-configmap vsi-id --env-from-configmap vsi-power-action-on

# create power off job
ibmcloud ce job create --name vsi-power-action-off --build-source . --wait --cpu .125 \
    --memory .25G --env-from-secret api-key --env-from-secret user-name \
    --env-from-configmap vsi-id --env-from-configmap vsi-power-action-off

# create power on cron job
ibmcloud ce sub cron create --name cron-vsi-power-on --destination \
    vsi-power-action-on --destination-type job --schedule "$POWER_ON_SCHEDULE"

# create power off cron job
ibmcloud ce sub cron create --name cron-vsi-power-off --destination \
    vsi-power-action-off --destination-type job --schedule "$POWER_OFF_SCHEDULE"
