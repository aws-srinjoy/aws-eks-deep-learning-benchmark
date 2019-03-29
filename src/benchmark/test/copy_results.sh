
NAMESPACE=$1
S3_BUCKET=$2

NFS_POD_NAME=$(kubectl --kubeconfig=$BENCHMARK_DIR/kubeconfig get pods -l role=kubebench-nfs -o jsonpath="{.items[0].metadata.name}")

kubectl cp ${NAMESPACE}/${NFS_POD_NAME}:/exports/kubebench/experiments ${BENCHMARK_DIR}/experiments

# Delete back up file which are noisy
rm aws-k8s-tester-eks.yaml.*.backup.yaml

BENCHMARK_ID=$(basename $BENCHMARK_DIR)
aws s3 cp ${BENCHMARK_DIR}/ s3://${S3_BUCKET}/${BENCHMARK_ID}/ --recursive --exclude "src/*"