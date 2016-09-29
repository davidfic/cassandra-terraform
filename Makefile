check-var-defined = $(if $(strip $($1)),,$(error "$1" is not defined))

plan: check-env clean
	terraform plan -refresh=true -out=./__plan-to-apply

apply: check-env
	terraform apply ./__plan-to-apply
	rm -f ./__plan-to-apply

clean:
	rm -f ./__plan-to-apply

provision: check-env
	./deploy-cassandra.sh

deploy: check-env plan apply provision

check-env:
	@echo Checking environment variables...
	$(call check-var-defined,AWS_ACCESS_KEY)
	$(call check-var-defined,AWS_SECRET_KEY)
	$(call check-var-defined,AWS_REGION)
	$(call check-var-defined,AWS_DEFAULT_REGION)

.PHONY: plan apply clean provision check-env deploy
