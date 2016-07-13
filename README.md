# kubernetes-on-coreos


## Vagrant


On your machine

- Move into the vagrant directory.
- Execute the `init-ansible-keys.sh` if you are on a windows host.
- Start the CoreOS virtual machines

```
$ cd vagrant
$ init-ansible-keys.sh # if you are on windows
$ vagrant up && vagrant ssh agent
```

In the "**agent**" session run the ansible `kube-agent.yml` and `kube-cluster.yml` playbooks. 


```
# Session: agent@/home/core
$ prepare-ansible  # Builds an ansible rkt image
$ cd ansible
$ run-playbook kube-agent.yml 
$ run-playbook kube-cluster.yml
```

**Attention:** the `kube-agent.yml` playbook might take some time to execute depending on the internet connection speed.  Part of its behaviour is to download and cache all external images and files required to bootstrap the cluster (**~1.5GB**). 
This technique allows recreating the cluster at any point in time with minimal network bandwidth requirements provided the **agent** host's state is preserved. In other words, don't `vagrant destroy` it.

The cluster will then be available from any machine through the `kubectl` tool.

```
$ kubectl cluster-info
Kubernetes master is running at https://172.17.4.101:443
KubeDNS is running at https://172.17.4.101:443/api/v1/proxy/namespaces/kube-system/services/kube-dns
```
