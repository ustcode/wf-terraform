CF_STACKNAME = github-oidc
CF_TEMPLATE = github-oidc.cf
CF_PARAMS = github-oidc.json

list: 
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


deploy: $(CF_TEMPLATE) $(CF_PARAMS) 
	aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name $(CF_STACKNAME) --template-body file://$(CF_TEMPLATE) --parameters file://$(CF_PARAMS)

update: $(CF_TEMPLATE) $(CF_PARAMS)
	aws cloudformation update-stack --capabilities CAPABILITY_IAM --stack-name $(CF_STACKNAME) --template-body file://$(CF_TEMPLATE) --parameters file://$(CF_PARAMS)

clean:
	aws cloudformation delete-stack --stack-name $(CF_STACKNAME)

.PHONY: list deploy update clean
