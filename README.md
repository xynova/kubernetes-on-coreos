# kubernetes-on-coreos


## Vagrant


On your machine

```
cd vagrant
vagrant up && vagrant ssh agent
```

Once in the agent session run the ansible playbook as following 

**Attention:** This will take a long time as it has to pull a few GB in docker image material :)

```
cd ansible
run-playbook kube-agent.yml kube-cluster.yml
```