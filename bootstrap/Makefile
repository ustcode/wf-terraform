CF_STACKNAME = github-oidc
CF_TEMPLATE = github-oidc.cf
CF_PARAMS = github-oidc.json
BUCKETNAME = $(shell aws cloudformation describe-stack-resources --stack-name $(CF_STACKNAME) --query 'StackResources[?LogicalResourceId==`TfBackend`].PhysicalResourceId' --output text)
ROLENAME = $(shell aws cloudformation describe-stack-resources --stack-name $(CF_STACKNAME) --query 'StackResources[?LogicalResourceId==`Role`].PhysicalResourceId' --output text)
ROLEARN = $(shell aws iam get-role --role-name $(RNAME) --query 'Role.Arn' --output text)

list: 
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


deploy: $(CF_TEMPLATE) $(CF_PARAMS) 
	aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name $(CF_STACKNAME) --template-body file://$(CF_TEMPLATE) --parameters file://$(CF_PARAMS)

update: $(CF_TEMPLATE) $(CF_PARAMS)
	aws cloudformation update-stack --capabilities CAPABILITY_IAM --stack-name $(CF_STACKNAME) --template-body file://$(CF_TEMPLATE) --parameters file://$(CF_PARAMS)

clean:
	aws cloudformation delete-stack --stack-name $(CF_STACKNAME)

.SILENT:
check:
	$(eval BNAME := $(BUCKETNAME))
	$(if $(findstring tfstate,$(BNAME)), $(info Terraform S3 Bucket Name: $(BNAME)), $(info Stack is not deployed, or deploy is incomplete.))
	$(eval RNAME := $(ROLENAME))
	$(if $(findstring Role,$(RNAME)), $(info Role Name: $(RNAME)), $(info Stack is not deployed, or deploy is incomplete.))
	$(eval RARN := $(ROLEARN))
	$(if $(findstring Role,$(RARN)), $(info Role ARN: $(RARN)), $(info Stack is not deployed, or deploy is incomplete.))

.PHONY: list deploy update clean
