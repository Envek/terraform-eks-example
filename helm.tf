provider "helm" {
  version = "~> 1.0" # For Helm 3
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "redis-test" {
  name   = "redis-test"
  chart  = "stable/redis"
  atomic = true

  set {
    name  = "cluster.enabled"
    value = false # In case of using t2.micro instances there are only 4 pods per nodes can be scheduled (and there are 3 system pods already on every node)
  }

  set {
    name  = "master.persistence.size"
    value = "100Mi"
  }

  set {
    name  = "master.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "master.resources.requests.memory"
    value = "128Mi"
  }

}
