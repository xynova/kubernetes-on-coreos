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
#> Session: agent@/home/core
$ prepare-ansible  #> Builds an ansible rkt image
$ cd ansible
$ run-playbook kube-agent.yml 
$ run-playbook kube-cluster.yml
```

**Attention:** the `kube-agent.yml` playbook might take some time to execute depending on the internet connection speed.  Part of its behaviour is to download and cache all external images and files required to bootstrap the cluster (**~1.5GB**). 
This technique allows recreating the cluster at any point in time with minimal network bandwidth requirements provided the **agent** host's state is preserved. In other words, don't `vagrant destroy` it.

The cluster will then be available from any machine through the `kubectl` tool.

```
#> Session: any vm
$ kubectl cluster-info

Kubernetes master is running at https://172.17.4.101:443
KubeDNS is running at https://172.17.4.101:443/api/v1/proxy/namespaces/kube-system/services/kube-dns
```

## Ansible on CoreOS
Ansible is setup to run from a **RKT** image that must be firstly built by executing the custom `prepare-ansible` command.  Ansible can then be run by executing the custom `run-playbook` or `run-module` commands.


```
#> Session: agent@/home/core
$ cd /home/core/ansible #> To leverage the ansible.cfg within the directory
$ run-playbook kube-agent.yml kube-cluster.yml

image: using image from local store for image name coreos.com/rkt/stage1-coreos:1.9.1
image: using image from local store for image name node.local/ansible:latest

PLAY [all] *************************************************************** 
...
```

```
#> Session: agent@/home/core
$ cd /home/core/ansible  #> To leverage the ansible.cfg within the directory
$ run-module all -m shell -a "echo $(pwd)'@'$(hostname)"

image: using image from local store for image name coreos.com/rkt/stage1-coreos:1.9.1
image: using image from local store for image name node.local/ansible:latest
172.17.4.51 | SUCCESS | rc=0 >>
/home/core/ansible@agent
172.17.4.101 | SUCCESS | rc=0 >>
/home/core/ansible@agent
172.17.4.201 | SUCCESS | rc=0 >>
/home/core/ansible@agent
172.17.4.10 | SUCCESS | rc=0 >>
/home/core/ansible@agent
```