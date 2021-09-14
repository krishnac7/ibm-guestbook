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
helm install mongo bitnami/mongodb --set global.storageClass=ibmc-block-gold,auth.password=$USER_PASS,auth.username=guestbookadmin,auth.database=guestbook,containerSecurityContext.enabled=false,podSecurityContext.enabled=false -n mongo
oc get all -n mongo
oc get pvc -n mongo
else
  echo "=== Script stopped ===";
fi
