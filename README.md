# Terraform example for Amazon EKS

Creates [Amazon's Elastic Kubernetes](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) service and installs stateful Redis into it.

This example is based on [Terraform's manual on EKS](https://learn.hashicorp.com/terraform/aws/eks-intro) with some parts replaced by more short [`eks_node_group`](https://www.terraform.io/docs/providers/aws/r/eks_node_group.html) declaration.

## Prerequisites

 1. Install terraform 
 2. [Install aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configure it](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) to your account
 3. Install kubectl and [helm](https://helm.sh/)
 4. Install [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator)

## Create a cluster

 1. Run `terraform init` to download binaries for providers: `aws`, `kubernetes`, `helm`
 2. Run `terraform apply` to create all the things (terraform will display what exactly and ask your consent)
 3. Wait patiently: it will take about 15 minutes.
 4. Insert generated kubectl configuration into `~/.kube/config` (don't forget to switch `current-context` to it!)
 5. Enjoy your cluster with `kubectl` and `helm`!
 6. …
 7. Don't forget to drop everything with `terraform destroy` (EKS isn't eligible for free tier and costs $0,10 per hour)

## What to do next?

For example, you can install [anycable-go](https://github.com/anycable/anycable-helm/) or [imgproxy](https://docs.imgproxy.net/#/installation?id=helm):

```sh
helm repo add anycable https://helm.anycable.io/
helm install anycable-go anycable/anycable-go --set "ingress.enable=false,env.anycableRedisUrl=redis://:$(kubectl get secret --namespace default redis-test -o jsonpath="{.data.redis-password}" | base64 --decode)@redis-test-master:6379/0" --wait --atomic
```

## What is missing?

Many things required for production usage: Ingress, authentication and authorization, …
