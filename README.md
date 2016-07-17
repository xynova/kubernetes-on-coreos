# Kubernetes v1.3 on CoreOS
The purpose of this project is to have a boostrapable version of Kubernetes that is easy to understand and explain to others. It has been configured to support high etcd and master nodes on availabiltiy mode.

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

## Boostrapping the cluster
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

## Running Ansible in CoreOS
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