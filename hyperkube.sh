#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Starts local hypercube cluster in a Docker container.
# Learn more at https://github.com/kubernetes/kubernetes/blob/master/docs/getting-started-guides/docker.md

# Version of kubernetes to use.
K8S_VERSION="v1.3.0"
# Version heapster to use.
HEAPSTER_VERSION="v1.0.2"
# Port of the apiserver to serve on.
PORT=8080
# Port of the heapster to serve on.
HEAPSTER_PORT=8082
docker network create k8s
docker run \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw,shared \
    --volume=/var/run:/var/run:rw \
    --pid=host \
    --name=launcher \
    -d \
    --privileged=true \
    gcr.io/google_containers/hyperkube-amd64:1.3.0 \
    /hyperkube kubelet \
        --allow-privileged=true \
        --hostname-override="127.0.0.1" \
        --address="0.0.0.0" \
        --api-servers=http://localhost:${PORT} \
        --config=/etc/kubernetes/manifests \
        --v=2

# Runs Heapster in standalone mode
docker run --net=k8s -d gcr.io/google_containers/heapster:${HEAPSTER_VERSION} -port ${HEAPSTER_PORT} \
    --source=kubernetes:http://127.0.0.1:${PORT}?inClusterConfig=false&auth=""

docker logs -f launcher