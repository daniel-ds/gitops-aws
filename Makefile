localstack_pod = $$(kubectl get pods | grep localstack | grep Running | awk '{print $$1}')
jenkins_pod = $$(kubectl get pods | grep localstack | grep Running | awk '{print $$1}')

localstack:
	helm upgrade --install localstack charts/localstack -f helm-values/localstack.yaml --wait
#	$(MAKE) forward-localstack

jenkins:
	helm upgrade --install jenkins stable/jenkins -f helm-values/jenkins.yaml --wait

jenkins-forward:
	kubectl port-forward $$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}") 8888:8080 &

jenkins-password:
	printf $$(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo


test:
#	echo "$$(echo ya) $(localstack_pod)"
	echo "$$(echo ya) "

blah:
	$(MAKE) forward-localstack

forward-localstack:
	@echo "forward s3"
	kubectl port-forward $(localstack_pod) 4572 &
	@echo "forward sns"
	kubectl port-forward $(localstack_pod) 4575 &
	@echo "forward sqs"
	kubectl port-forward $(localstack_pod) 4576 &
	@echo "forward localstack dashboard"
	kubectl port-forward $(localstack_pod) 8080 &

minikube:
	minikube start --cpus 4 --memory 4096 --kubernetes-version v1.13.5
	helm init --wait
	$(MAKE) localstack
	$(MAKE) forward-localstack
