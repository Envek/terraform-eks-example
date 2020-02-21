provider "kubernetes" {
  version = "~> 1.11"

  host = aws_eks_cluster.eks-demo-cluster.endpoint
}
