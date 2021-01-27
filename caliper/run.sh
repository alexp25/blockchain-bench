# npm install --only=prod @hyperledger/caliper-cli@unstable
# npx caliper bind --caliper-bind-sut fabric --caliper-bind-sdk 2.1.0

# Set workspace as caliper-benchmarks root
WORKSPACE=$(cd "$(dirname '$1')/." &>/dev/null && printf "%s/%s" "$PWD" "${1##*/}")
echo ${WORKSPACE}

# Nominate a target network
NETWORK=networks/fabric/v2/v2.1.0/2org1peercouchdb_raft/api/fabric-api-solo-node.yaml

# Enable tests to use existing caliper-core package
#export NODE_PATH=$(which node)

# Build config for target network
# cd ${WORKSPACE}networks/fabric/config_solo_raft
# ./generate.sh
# cd ${WORKSPACE}

# Available benchmarks
BENCHMARK_NAMES=("get_asset" "get_asset_batch" "create_asset" "create_asset_batch")
BENCHMARKS=("benchmarks/api/fabric/test/get-asset.yaml" "benchmarks/api/fabric/test/get-asset-batch.yaml" "benchmarks/api/fabric/test/create-asset.yaml" "benchmarks/api/fabric/test/create-asset-batch.yaml")
# Selected benchmarks
BENCHMARK_NAMES=("get_asset_batch")
BENCHMARKS=("benchmarks/api/fabric/test/get-asset-batch.yaml")
# Available phases
PHASES_INIT=("caliper-flow-only-start" "caliper-flow-only-init" "caliper-flow-only-install")
PHASES_TEST=("caliper-flow-only-test")
PHASES_CLEANUP=("caliper-flow-only-end")
PHASES=("caliper-flow-only-start" "caliper-flow-only-init" "caliper-flow-only-install" "caliper-flow-only-test" "caliper-flow-only-end")
REPS=1
BENCH_INDEX=0
BENCH_INDEX_END=1000

COUNTER=0
while [  $COUNTER -lt $REPS ]; do
    echo "test iteration #" $COUNTER
    let COUNTER=COUNTER+1     
done

for BENCHMARK in ${BENCHMARKS[@]}; do
    echo "test bench #" $BENCH_INDEX
    echo ${BENCHMARK_NAMES[BENCH_INDEX]}
    let BENCH_INDEX=BENCH_INDEX+1
    if [ $BENCH_INDEX -gt $BENCH_INDEX_END ]
    then
        break
    fi
done

# exit 1

# cp report.html report_blank.html
BENCH_INDEX=0
COUNTER=0
# exit 1


# Execute Phases
function runBenchmark () {
    PHASE=$1
    BENCHMARK=$2
    sudo npx caliper launch manager \
    --caliper-workspace ${WORKSPACE} \
    --caliper-benchconfig ${BENCHMARK} \
    --caliper-networkconfig ${NETWORK} \
    --caliper-fabric-gateway-enabled \
    --${PHASE}

    sleep 5s
} 

# Repeat for BENCHMARK
for BENCHMARK in ${BENCHMARKS[@]}; do
    echo "running bench: " ${BENCHMARK}

    # setup nodes
    echo "setup nodes"
    for PHASE in ${PHASES_INIT[@]}; do	
        echo "running setup phase: " ${PHASE}
        runBenchmark ${PHASE} ${BENCHMARK}
    done

    # run benchmark multiple times
    echo "running bench"
    COUNTER=0
    while [  $COUNTER -lt $REPS ]; do
        echo "iteration #" $COUNTER
        let COUNTER=COUNTER+1 
        for PHASE in ${PHASES_TEST[@]}; do	
            runBenchmark ${PHASE} ${BENCHMARK}
        done
        # copy report
        cp report.html report_${BENCHMARK_NAMES[BENCH_INDEX]}_run_${COUNTER}.html
        let COUNTER=COUNTER+1 
    done
    
    # cleanup nodes
    echo "cleanup nodes"
    for PHASE in ${PHASES_CLEANUP[@]}; do
        echo "running cleanup phase: " ${PHASE}	
        runBenchmark ${PHASE} ${BENCHMARK}
    done    

    let BENCH_INDEX=BENCH_INDEX+1

    if [ $BENCH_INDEX -gt $BENCH_INDEX_END ]
    then
        break
    fi
    
done