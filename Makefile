help:
	@echo
	@echo "-----------------------------------------"
	@echo ".-.-.-. SYMANEX SITE BUILD SYSTEM .-.-.-."
	@echo "-----------------------------------------"
	@echo
	@echo "AVAILABLE OPTIONS:"
	@echo
	@echo "make build\tbuild a new Docker image"
	@echo "make run\trun the latest Docker image locally"
	@echo "make deploy\tdeploy the latest Docker image to AWS ECR"
	@echo "make release\trelease to latest Docker image to AWS ECS"
	@echo "make clean\tclean up all local dangeling Docker images"
	@echo "make mrproper\tremove all local symanex-site images"
	@echo

all: build deploy release clean

build:
	docker build -t symanex-site:latest .
	docker tag symanex-site:latest 928205109583.dkr.ecr.eu-west-1.amazonaws.com/symanex-site:latest

run:
	docker run --rm -d --name symanex-site -p 8080:80 symanex-site:latest

deploy:
	`aws ecr get-login --region eu-west-1`
	docker push 928205109583.dkr.ecr.eu-west-1.amazonaws.com/symanex-site:latest

release: deploy
	aws ecs update-service --cluster symanex-dev --service symanex-site --task-definition symanex-site:$(shell aws ecs register-task-definition --cli-input-json file://symanex-site.json --output json | jq '.taskDefinition.revision')

.PHONY: clean

clean:
	docker rmi `docker images -f "dangling=true" -q`

mrproper: clean
	docker rmi symanex-site
