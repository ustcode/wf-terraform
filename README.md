# Reference Pipeline: Terraform on AWS

This template demonstrates the pieces needed for a basic implementation of configuration control and CI/CD of [Terraform](https://www.terraform.io/)-based Infrastructure-as-Code (IaC).

## Overview

The mechanisms implemented by this template are heavily inspired by the objectives described by the Configuration Management (CM) requirement of FIPS 200 and the control objectives in the CM family of NIST SP 800-37.  Most notably:

- [CM-3: Configuration Change Control](https://csf.tools/reference/nist-sp-800-53/r5/cm/cm-3/)
- [CM-3(1): Automated Documentation, Notification, and Prohibition of Changes](https://csf.tools/reference/nist-sp-800-53/r5/cm/cm-3/cm-3-1/)
- [CM-3(2): Testing, Validation, and Documentation of Changes](https://csf.tools/reference/nist-sp-800-53/r5/cm/cm-3/cm-3-2/)
- [CM-3(3): Automated Change Implementation](https://csf.tools/reference/nist-sp-800-53/r5/cm/cm-3/cm-3-3/)
- [CM-4: Impact Analysis](https://csf.tools/reference/nist-sp-800-53/r5/cm/cm-4/)
- [MA-2: Controlled Maintenance](https://csf.tools/reference/nist-sp-800-53/r5/ma/ma-2/)
- [MA-2(2): Automated Maintenance Activities](https://csf.tools/reference/nist-sp-800-53/r5/ma/ma-2/ma-2-2/)

To implement thse control objectives, the following guidelines need to be applied:

- `Github Code Owners`: Configure branch protection rules so that only appropriate [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) can approve merges.
- `Github Environment`: Configure the environments to require reviewers to approve workflow runs that modify infrastructure.
- `Bootstrap AWS`: Configure an [AWS IAM WebIdentity Role and link it to Github](https://github.com/aws-actions/configure-aws-credentials).  Refer to the [bootstrap](bootstrap/) directory for instructions (TODO).

## Workflow

The wf-terraform workflow has four conceptual steps.

![Reference Architecture](../assets/img/architecture.png?raw=true)

1. Commit changes to the [root terraform module](https://www.terraform.io/language/modules) onto a branch of your IaC repository and create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) (PR).  
   
2. The [pull request workflow](.github/workflows/tfpr.yml) will execute a [terraform plan](https://www.terraform.io/cli/commands/plan) and post the output to a comment in the pull request.

3. Review the pull request.  If necessary, make further changes to the module/plan through additional commits.  The additional commits will trigger reruns of the pull request workflow, and the comment in the pull request will be updated automatically.  Once the [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) approve the PR, [merge the request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request) to the main branch.

4. The [apply workflow](.github/workflows/tfmain.yml) will execute a [terraform apply](https://www.terraform.io/cli/commands/apply).  Records of the apply can be reviewed in the GitHub Actions logs.
