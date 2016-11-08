check-var-defined = $(if $(strip $($1)),,$(error "$1" is not defined))
NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

plan: check-env clean
	@echo "$(OK_COLOR)==> Running plan$(NO_COLOR)"
	terraform plan -refresh=true -out=./__plan-to-apply

apply: check-env
	@echo "$(OK_COLOR)==> Apply$(NO_COLOR)"
	terraform apply ./__plan-to-apply
	rm -f ./__plan-to-apply

clean:
	@echo "$(OK_COLOR)==> Cleaning up$(NO_COLOR)"
	rm -f ./__plan-to-apply

provision: check-env
	@echo "$(OK_COLOR)==> Provision$(NO_COLOR)"
	./deploy-cassandra.sh

deploy: check-env plan apply provision
	@echo "$(OK_COLOR)==> Deploy$(NO_COLOR)"

check-env:
	@echo "$(OK_COLOR)==> Checking environment variables$(NO_COLOR)"
	$(call check-var-defined,AWS_ACCESS_KEY)
	$(call check-var-defined,AWS_SECRET_KEY)
	$(call check-var-defined,AWS_REGION)
	$(call check-var-defined,AWS_DEFAULT_REGION)

.PHONY: plan apply clean provision check-env deploy
