.DEFAULT_GOAL := help

LOCAL_PROJECT_NAME = local
REGISTRY_PORT = 37893

.PHONY: help
help: ## View help information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: asdf-bootstrap
asdf-bootstrap: ## Install all tools through asdf-vm
	asdf plugin-add flux2   || asdf install flux2
	asdf plugin-add k3d     || asdf install k3d
	asdf plugin-add kubectl || asdf install kubectl

.PHONY: k8s-bootstrap
k8s-bootstrap: ## Create a Kubernetes cluster for local development
	k3d cluster create $(LOCAL_PROJECT_NAME) -a 1 -p "8000:80@loadbalancer" --k3s-arg "--no-deploy=metrics-server@server:*" || echo "Cluster already exists"
	sleep 3 && kubectl config use-context k3d-$(LOCAL_PROJECT_NAME)


.PHONY: flux-bootstrap
flux-bootstrap: ## Install flux and bootstrap local overlay
	flux install
	flux create source git cluster-management \
	    --url=https://github.com/dannylongeuay/cluster-management \
	    --branch=main
	flux create kustomization bootstrap \
		--source=GitRepository/cluster-management \
		--path="./bootstrap/overlays/local" \
		--prune=true \
		--interval=30s
	
.PHONY: bootstrap
bootstrap: asdf-bootstrap k8s-bootstrap flux-bootstrap ## Perform all bootstrapping required for local development

.PHONY: create
create: bootstrap ## Create local development environment
	@echo "Created k3d cluster and bootstrapped GitOps tools"

.PHONY: clean
clean: ## Destroy local development environment
	k3d cluster delete $(LOCAL_PROJECT_NAME) || echo "No cluster found"
	
.PHONY: create-gitlab-secret
create-gitlab-secret: ## Create a gitlab secret to be used with the external secrets store
	cp gitlab-secret.example.yaml gitlab-secret.yaml

.PHONY: apply-gitlab-secret
apply-gitlab-secret: ## Apply a gitlab secret to be used with the external secrets store
	kubectl apply -f gitlab-secret.yaml
