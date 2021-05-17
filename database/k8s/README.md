# WHAT IS THIS?

These are the YAML files needed to deploy polizai into a Kubernetes cluster.

It also includes a Script to modify variables within the YAMLs.
- But why?
- to avoid saving real paths, passwords and so on on Github.

# TLDR;
Run ./config.sh
Run:
```for i in $(ls *.yaml); do kubectl apply -f $i; done```, or whatever your kubectl command is
