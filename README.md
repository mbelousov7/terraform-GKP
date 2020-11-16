# kubernetes-GKP-terraform
simple module and example for manage kubernetes clusters in GKE by terraform


##Setup the GCP environment
1.  Installing Google Cloud SDK, see https://cloud.google.com/sdk/install
2.  Auth in your GCP account
```
gcloud auth login
```
3. Create a GCP project
  - configure GCP
```
export GCP_BILLING_ACCOUNT_ID=<YOUR_BILLING_ACCOUNT_ID>
export GCP_PROJECT_ID=<YOUR_GCP_PROJECT_ID>
export GCP_TF_SA=<YOUR_TERRAFORM_SA_NAME>

gcloud projects create ${GCP_PROJECT_ID} --set-as-default
gcloud beta billing projects link ${GCP_PROJECT_ID} --billing-account ${GCP_BILLING_ACCOUNT_ID}
```
*Note
YOUR_BILLING_ACCOUNT_ID - you can find it by run gcloud beta billing accounts list
YOUR_GCP_PROJECT_ID - GCP project ID to create
YOUR_TERRAFORM_SA_NAME - name for terraform service account in GCP
**

3. Create the Terraform service account and key file in secret directory
```
gcloud iam service-accounts create ${GCP_TF_SA} \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ./secrets/${GCP_PROJECT_ID}-sa.json \
  --iam-account ${GCP_TF_SA}@${GCP_PROJECT_ID}.iam.gserviceaccount.com
```
4. Grant nessery service account permission for ${GCP_TF_SA}
```
gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
  --member serviceAccount:${GCP_TF_SA}@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/owner
```
5. Any actions that Terraform performs require that the API be enabled to do so. In this guide, Terraform requires the following:
```
gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
```

##Run Terraform example
1. Define main terraform variables
```
export TF_VAR_project=${GCP_PROJECT_ID}
export TF_VAR_file_sa=./secrets/${GCP_PROJECT_ID}-sa.json
```
2. Create workspace for your project(enviroment)
```
cd example
terraform workspace new ${GCP_PROJECT_ID}

```
3. Run terraform
```
terraform workspace select ${GCP_PROJECT_ID}
terraform init
terraform plan -var-file="./env/${GCP_PROJECT_ID}.tfvars"
terraform apply -var-file="./env/${GCP_PROJECT_ID}.tfvars"
terraform destroy -var-file="./env/${GCP_PROJECT_ID}.tfvars"
```

##re-run example
```
cd example
export GCP_PROJECT_ID=mbelousov-kubernetes-laba
export TF_VAR_project=${GCP_PROJECT_ID}
export TF_VAR_file_sa=./env/${GCP_PROJECT_ID}-sa.json
terraform workspace select ${GCP_PROJECT_ID}
terraform init
terraform plan -var-file="./env/${GCP_PROJECT_ID}.tfvars"
terraform apply -var-file="./env/${GCP_PROJECT_ID}.tfvars"
terraform destroy -var-file="env/${GCP_PROJECT_ID}.tfvars"
```
