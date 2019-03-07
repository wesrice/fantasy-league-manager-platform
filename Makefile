build:
	@echo "Beginning build..."
	@rm -rf .tmp
	@rm -rf dist
	@mkdir .tmp
	@echo "Downloading latest Swagger UI..."
	@$(eval tarball_url := $(shell curl -s https://api.github.com/repos/swagger-api/swagger-ui/releases/latest | grep tarball_url | cut -d '"' -f 4))
	@curl -sL $(tarball_url) -o .tmp/swagger-ui.tar.gz
	@tar xz -f .tmp/swagger-ui.tar.gz -C .tmp --strip-components 1
	@mv .tmp/dist dist
	@rm -rf .tmp
	@echo "Downloading Fantasy League Manager Platform spec..."
	@curl -s https://fantasy.espn.com/apis/v3/swagger.json -o dist/swagger.json
	@sed -i -e "s|url: \"https://petstore.swagger.io/v2/swagger.json\"|url: \"https://wesrice.github.io/fantasy-league-manager-platform/swagger.json\"|g" dist/index.html
	@echo "Build finished!"

deploy:
	@echo "Deploying..."
	@GIT_DEPLOY_DIR=./dist \
		GIT_DEPLOY_BRANCH=gh-pages \
		GIT_DEPLOY_REPO=git@github.com:wesrice/fantasy-league-manager-platform.git ./deploy.sh
	@echo "Deploy finished!"

build-and-deploy: build deploy

.PHONY: build deploy build-and-deploy
