# Hyperledger Caliper Benchmarks
This repository contains sample benchmarks that may be used by Caliper, a blockchain performance benchmark framework. For more information on Caliper, please see the [Caliper main repository](https://github.com/hyperledger/caliper/)

## additional notes

# setup node, npm
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-18-04

# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker <your-user>

# docker compose
https://docs.docker.com/compose/install/
sudo curl -L "<https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)>" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# caliper
https://hyperledger.github.io/caliper/v0.4.2/installing-caliper/#local-npm-install
https://github.com/hyperledger/caliper-benchmarks

# git clone caliper-benchmarks
# install caliper inside caliper-benchmarks
npm install --only=prod @hyperledger/caliper-cli@0.4.0
npx caliper bind --caliper-bind-sut fabric --caliper-bind-sdk 1.4.0
npx caliper bind --caliper-bind-sut fabric --caliper-bind-sdk 2.1.0

# generate network config
network/fabric/config_solo/generate.sh
network/fabric/config_solo_raft/generate.sh

# run benchmark
sudo npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarks/api/fabric/test1.yaml --caliper-networkconfig networks/fabric/v2/v2.1.0/2org1peercouchdb_raft/api/fabric-api-solo-node.yaml --caliper-fabric-gateway-usegateway

# TIMEOUT
I modify the file caliper/src/fabric/e2eUtils.js request_time
and the file caliper/node_modules/fabric-client/config/default.json
change from 45000 to 85000

# configure test
read
https://hyperledger.github.io/caliper-benchmarks/fabric/performance/2.1.0/goContract/nodeSDK/evaluate/get-asset/
batch read
https://hyperledger.github.io/caliper-benchmarks/fabric/performance/2.1.0/goContract/nodeSDK/evaluate/batch-get-asset/
write
https://hyperledger.github.io/caliper-benchmarks/fabric/performance/2.1.0/goContract/nodeSDK/submit/create-asset/
batch write
https://hyperledger.github.io/caliper-benchmarks/fabric/performance/2.1.0/goContract/nodeSDK/submit/batch-create-asset/

# benchmark test settings
https://hyperledger.github.io/caliper/v0.3.2/bench-config/#benchmark-test-settings


Info:
#common
- number of workers: 10
number of workers that execute the workload (number of clients that send requests simultaneously)
- rateControl.tps: 100
transactions per second for each worker
- txDuration: 30
duration of the experiment
#test1
get latency by asset size


