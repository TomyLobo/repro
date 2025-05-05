resource "kind_cluster" "this" {
    name = "kind-repro-ingress-nginx-race-condition"
    kubeconfig_path = "kubeconfig_kind"
}
