# kubernetes-on-coreos


## Vagrant


On your machine

```
# Move into the vagrant directory
cd vagrant

# execute the following if you are on a windows host
init-ansible-keys.sh

# UP the CoreOS virtual machines
vagrant up && vagrant ssh agent
```

Once in the agent session run the ansible playbook as following 

**Attention:** This will take a long time as it has to pull a few GB in docker image material :)

```
# You should be in the /home/core dir
# Move into the ansible directory
cd ansible

# Run the playbooks 
# the agent playbook will download and cache all 
# required container images
run-playbook kube-agent.yml kube-cluster.yml
```