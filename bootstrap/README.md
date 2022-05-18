# Bootstrap Instructions

This folder provides instructions and tools for bootstrapping GitHub Actions Terraform in this project.  

Steps:

1. Complete prerequisites.
   
2. Update `github-oidc.json` with account specific parameters.

3. Bootstrap the AWS account.

4. Configure the Terraform backend.

5. Commit the changes.

## 1. Prerequisites

- Install the [AWS CLI](https://aws.amazon.com/cli/) on a local workstation.
- Configure the AWS CLI with AdministratorAccess credentials.  Note: lesser permissions may be possible, but not tested.
- Create a repository (typically private) with the assets from [wf-terraform](https://github.com/ustcode/wf-terraform).

## 2. Setup: github-oidc.json

This file is used to parameterize the deployment of a IAM Role and S3 bucket.  The S3 bucket will be used by terraform to maintaim the [tfstate](https://www.terraform.io/language/state) between executions.  The IAM role is assumed by the GitHub Actions during workflow runs.

### Parameter: GitHubRepoName

The `org/name` of the GitHub repository that will be used to manage the AWS account.

Example: `ustcode/wf-terraform`

### Parameter: OIDCProviderArn (optional)

The ARN for the GitHub OIDC provider.  Provide this if the OIDC provider has been provisioned through another means.

Example: `arn:aws-us-gov:iam::012345678901:oidc-provider/token.actions.githubusercontent.com`

### Parameter: ManagedPolicy

The name of an [AWS-managed IAM policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies) that will be used to provide permissions to GitHub Actions.  Default: PowerUserAccess.

## 3. Bootstrap the AWS Account

Execute `make deploy`.  You should see output similar to as follows

```bash
$ make deploy
{
    "StackId": "arn:aws:cloudformation:us-gov-west-1:123456789012:stack/github-oidc/12376d80-d460-16ec-a17c-0ae7fb2c5f31"
}

```

Allow some time for the stack to deploy; typically, this takes about 30 seconds.  Then check the status using a `make check`.

```bash
$ make check
An error occurred (ValidationError) when calling the DescribeStackResources operation: Stack with id github-oidc does not exist
Stack is not deployed, or deploy is incomplete.

$ make check
Terraform S3 Bucket Name: tfstate-13726d80
```

Save the S3 bucket name for the last step.

## 4. Configure the Terraform Backend

The terraform backend is configured in the `terraform.tf` file.  It should look something like this:

```json
terraform {
  backend "s3" {
    region  = "us-gov-west-1"
    bucket  = "BUCKETNAME"
    key     = "ORGANIZATION/REPOSITORY/terraform.tfstate"
    encrypt = "true"
  }
}

`BUCKETNAME`: Use the bucket name from step 3.
`ORGANIZATION/REPOSITORY`: Use the value from GitHubRepoName in step 2
```

## 5. Commit the changes...

...and check refer to [/README.md](/README.md) for further details!  The first run will set up `terraform.tfstate` in the S3 bucket.