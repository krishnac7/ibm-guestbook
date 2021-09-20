echo "=== Creating new project ==="
oc new-project mongo
oc project mongo
echo "=== Adding bitnami to repos ==="
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongo bitnami/mongodb --set global.storageClass=ibmc-block-gold,auth.password=testing,auth.username=guestbookAdmin,auth.database=guestbook -n mongo --dry-run >> mongdb-install-dryrun.yaml
cat mongdb-install-dryrun.yaml
read -p "=== Continue to install (y/n)? " CONT
if [ "$CONT" = "y" ]; then
USER_PASS=`openssl rand -base64 12 | tr -d "=+/"`
helm install mongo bitnami/mongodb --set global.storageClass=ibmc-block-gold,auth.password=$USER_PASS,auth.username=guestbook-admin,auth.database=guestbook,containerSecurityContext.enabled=false,podSecurityContext.enabled=false -n mongo
export MONGODB_PASSWORD=$(kubectl get secret --namespace mongo mongo-mongodb -o jsonpath="{.data.mongodb-password}" | base64 --decode)
export MONGODB_PASSWORD=$(kubectl get secret --namespace mongo mongo-mongodb -o jsonpath="{.data.mongodb-password}" | base64 --decode)
oc get all -n mongo
oc get pvc -n mongo
echo "=== Please wait till PV is created and mongo pod is up, it usually takes upto 3 minutes ==="
echo "=== Use `oc pods -n mongo` to check if the pod is status === "
else
  echo "=== Script stopped ===";
fi
