echo "=== seting working directory to current directory ==="
WORK_DIR=`pwd`
cd $WORK_DIR
echo "=== Cloning IBM Guestbook git repo ==="
git clone https://github.com/IBM/guestbook-nodejs.git --branch mongo-db
git clone https://github.com/IBM/guestbook-nodejs-config/ --branch lab
echo "=== Cloning complete.. ==="
cd $WORK_DIR/guestbook-nodejs/src
echo "=== Showing datasources.json.. ==="
cat server/datasources.json
echo "=== Showing model-configs.json.. ==="
cat server/model-config.json
read -p "=== Continue to deploy (y/n)? " CONT
if [ "$CONT" = "y" ]; then
cd $WORK_DIR/guestbook-nodejs-config
echo "=== Showing guestbook-deployment.yaml.. ==="
cat guestbook-deployment.yaml
echo "=== Creating secret for mongodb access.. ==="
oc create secret generic mongodb --from-literal=username=guestbook-admin --from-literal=password=$USER_PASS -n mongo
cd $WORK_DIR/guestbook-nodejs-config/
echo "=== Applying guestbook yamls.. ==="
oc apply -f . -n mongo
HOSTNAME=`oc get nodes -ojsonpath='{.items[0].metadata.labels.ibm-cloud\.kubernetes\.io\/external-ip}'`
SERVICEPORT=`oc get svc guestbook -n mongo -o=jsonpath='{.spec.ports[0].nodePort}'`
echo "=== App available at -> http://$HOSTNAME:$SERVICEPORT ==="
oc get pods -n mongo
else
  echo "=== Script stopped ===";
fi
