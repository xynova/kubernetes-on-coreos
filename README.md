# Kubernetes v1.4 on CoreOS
The purpose of this project is to have a boostrapable version of Kubernetes that is easy to understand and explain to others. It has been configured to support the following:

- Etcd on high availability mode support
- Master nodes on high availabiltiy mode support 
- Secure SSH communications between master and minion nodes.
- Flannel overlay network
- Kubectl access from all nodes

## Vagrant


#### On your machine :

- Move into the vagrant directory.
- Execute the `init-ansible-keys.sh` if you are on a windows host.
- Start the CoreOS virtual machines

```
cd vagrant
```
If you are on a windows host, run the following to create Ansible ssh keys
```
init-ansible-keys.sh      
```
Boot up the machines
```
vagrant up && vagrant ssh agent
```

## Boostrapping the cluster from the `agent` node
#### On the `core @ agent` session :

- Build the ansible RKT image.
- Move into the ansible directory.
- Run the ansible playbooks to bootrap the repeatable cluster.

```
prepare-ansible
```
```
cd ansible
```

```
run-playbook kube-agent.yml 
```
> The kube-agent playbook will download and cache all external docker images and files required to bootstrap the cluster (**~1.5GB**). Technique allows for continuous destroying and recreation of the cluster with minimal network bandwidth requirements (do not destroy the **agent** host's host).
**Attention:** This might take some time and bandwidth to execute as it needs to download the docker images and binaries from the internet. 

```
run-playbook kube-cluster.yml
```


#### On the `core @ [any-machine]` session :

Test yout cluster  cluster with the the `kubectl` tool.

```
kubectl cluster-info
```
``` 
kubectl get cs
```
``` 
kubectl get pods
```

## Boostrapping the cluster from a Mac
- Get ansible installed on your machine
- Install kubectl using brew
- Move into the ansible directory.
- Run the ansible playbooks to bootrap the repeatable cluster.
- Copy down the kubeconfig files required by kubectl to connect to the cluster.

Install ansible and netaddr module. As a recommendation, setup a virtual environments using py-env and pyenv-virtualenv.
```
pip install ansible==2.1.2.0
pip install netaddr==0.7.18
```

Install kubectl using brew package manager
```
brew install kubernetes-cli
```

Move into the ansible directory located at the same level as the vagrant directory
```
cd .. # (if you are were the vagrant directory)
cd ansible
```
Just both boostrapping playbooks 
```
ansible-playbook kube-agent.yml 
```
> The kube-agent playbook will download and cache all external docker images and files required to bootstrap the cluster (**~1.5GB**). Technique allows for continuous destroying and recreation of the cluster with minimal network bandwidth requirements (do not destroy the **agent** host's host).
**Attention:** This might take some time and bandwidth to execute as it needs to download the docker images and binaries from the internet.

```
run-playbook kube-cluster.yml
```

In order to connect to the cluster from the local machine, we just bring the kubeconfig files down from the *agent* machine
and setup an environment variable for the `kubectl` command to reference them.

```
# from the project root directory
scp -i .ssh/id_rsa -r core@172.17.4.10:/home/core/kubeconfig-bundle .kube
export KUBECONFIG=$(pwd)/.kube/config
```

## How is Ansible run from a CoreOS node?
Ansible is setup to run from a **RKT** image that must be firstly built by executing the custom `prepare-ansible` command.  Ansible can then be run by executing the custom `run-playbook` or `run-module` commands.

#### On the `core @ agent` session :
Move into the ansible directory in order for ansible to use the ansible.cfg within the directory
```
cd /home/core/ansible 
```
To execute playbooks use the `run-playbook` custom commmand
```
$ run-playbook kube-agent.yml kube-cluster.yml
```
To execute adhoc commands use the `run-module` custom command
```
$ run-module all -m shell -a "echo $(pwd)'@'$(hostname)"
```