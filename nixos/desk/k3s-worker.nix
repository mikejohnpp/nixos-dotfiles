{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    8080
    443
    80
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.k3s = {
    enable = true;
    role = "agent";
    token = "K10f968e0f05fee3d5c0abea5c6a7dd955924cc7a048a5dd384205879157a17b0d5::server:1fa906d24af6a0bdcb198ca2c8fd6a18";
    serverAddr = "https://192.168.1.180:6443";
    extraFlags = toString [
      "--debug" # Optionally add additional args to k3s
      "--node-name=desk-worker-1"
      "--with-node-id"
    ];
  };

  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        # helm-s3
        helm-git
      ];
    })
  ];

  environment.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

}
