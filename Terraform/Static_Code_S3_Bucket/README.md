Introduction



Terraform is a command line utility that allows a user to create scripts for building AWS infrastructure. These scripts can then be run to instantly build a set of AWS infrastructure without having to manually build the infrastructure through the AWS management console. An advantage of Terraform is that it is highly modular and reusable. A Terraform script can include variables that allow the user to customize their configuration, and Terraform scripts can be run over and over again to create multiple copies of similar infrastructure.

In order to use Terraform you must configure your AWS API credentials as enviornment variables.  

To do this run the below from a terminal.

export AWS_ACCESS_KEY_ID = AKIAKDKAKDKDFKKSDFKDSKFS

export AWS_SECRET_ACCESS_KEY = AKIAKDKAKDKDFKKSDFKDSKFSAKIAKDKAKDKDFKKSDFKDSKFS


Running Terraform Scripts



Terraform scripts are a collection of files that reside in the same root directory. In order to run these scripts, you must be in the root directory where the files are located.

Terraform Commands:

terraform init: This command must be run first when running a Terraform script. It initializes the script directory for Terraform and downloads plugins necessary for Terraform.

terraform plan: This command shows you a preview of all the infrastructure that will be created. You can see what resources will be created, updated, or destroyed and every individual attribute of each resource.

terraform apply: Run this command when you are ready to actually run the script and make changes to your infrastructure. Like terraform plan, it will show you a preview of what you are going to create. It will then ask you if you would like to make the changes. Type yes to make the changes or type no to cancel changes.



Divy Onboarding Scripts



The following scripts are used to set up S3 buckets for Divy. In this repository, you will see two directories called 1-Optional_Logging_Bucket and 2-Mandatory_Code_Bucket. These are two separate scripts that are run independently to create the necessary infrastructure. The infrastructure consists of a main bucket for storing source code and an optional logging bucket for sending logs to.


1-Optional_Logging_Bucket



The optional logging bucket script is used to create a logging bucket that the main bucket will send logs to. If you wish not to enable logging on the main bucket, you can skip running this script.



Change into the directory of the optional logging bucket script after cloning the repository.


Run terraform init to initialize the directory for Terraform


Run terraform apply, you will then be asked for the following variables to input:


log_bucket_name: The name of the S3 bucket used for logging. This name must be all lowercase and meet other naming standards. It must be globally unique across the entire AWS platform. If the name has already been used by another user, the script will throw an error.


Review your changes. Enter yes to confirm your changes. Everything should be created.


2-Mandatory_Code_Bucket


The mandatory code bucket script is used to create the code bucket for storing source code for Divy. It will also create an IAM user and policies for accessing the S3 bucket. You can optionally configure the bucket to have logging and KMS encryption. If KMS encryption is enabled on the bucket it will also create the necessary KMS infrastructure.


Change into the directory of the mandatory code bucket script after cloning the repository.


Run terraform init to initialize the directory for Terraform


Run terraform apply, you will then be asked for the following variables to input:

Create_log_bucket: This variable determines whether or not you would like to enable    
logging on the S3 bucket. This can be set to either true or false.

Encrypt_bucket: This variable determines whether or not KMS encryption should be     
enabled on the S3 bucket. This can be set to either true or false.

Iam-username: The username for your IAM user. Can be set to any value.

KMS_key_alias: An alias used to easily identify the KMS key in the console. Can be any 
value. If encrypt_bucket is set to false, this can be skipped by pressing enter to enter a 
blank value.

Log_bucket_name: The name of the S3 bucket used for logging (created previously). This name must be all lowercase and meet other naming standards. It must be globally unique across the entire AWS platform. If the name has already been used by another user, the script will throw an error. If create_log_bucket is set to false, this can be skipped by pressing enter to enter a blank value.

Main_bucket_name: The name of the mandatory code S3 bucket. This name must be all  
lowercase and meet other naming standards. It must be globally unique across the entire 
AWS platform. If the name has already been used by another user, the script will throw 
an error.

Region: The AWS region, such as us-east-1, or us-west-2.


Review your changes. Enter yes to confirm your changes. Everything should be created.


The following resources will be created. You can review your changes before running to 
see that this is accurate.

Aws_s3_bucket: The main S3 bucket.

Aws_iam_user: An IAM user for accessing the bucket.

Aws_iam_user_policy.s3_access: Policy for giving the IAM user access to the main S3 bucket.



If you enable KMS encryption, the following additional resources will be created:

Aws_kms_key: KMS key

Aws_kms_alias: Alias for the KMS key

Aws_iam_user_policy.kms_access: Policy to allow the user to access the KMS key.


After running the script, it will output the bucket name and the AWS access key ID to the console.
The AWS secret access key is encrypted and must be decrypted by iSystematics. Send the terraform.tfstate file for the mandatory code bucket script
to iSystematics for us to decrypt the secret key. This file should be created in the directory you ran the script in
after running it.
