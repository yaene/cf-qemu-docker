# Build docker container

```bash
# network=host to avoid dependency fetch failures with bazel on my machine
docker build --network=host -t cuttlefish .
```
