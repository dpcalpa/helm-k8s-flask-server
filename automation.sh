#!/bin/bash

#• Build
#• Local unit tests
#• Package
#• Deploy
#• Smoke test

DOCKER="python-app"
HELM_APP="app"

#Clone repository
git clone https://github.com/dpcalpa/flask-server.git

#Install dependencies locally assuming you have Mac machine and brew installed
#Python 
brew install python
#Pip
sudo easy_install pip
#Flask
pip3 install -r requirements.txt
#Helm 
brew install helm

#Run unit tests to app.py
python app/tests/test.py

#Make docker build to get image python-app:latest
cd flask-server
docker build -t $DOCKER:latest .
cd ..
echo "BUILD done"
echo "IMAGE $DOCKER:latest listed"
docker container ls

#Install Helm Chart
helm install $HELM_APP .

#Wait until kubernetes deploys configuration
sleep 10

#Smoke test
echo "Test app on fixed nodePort with: curl -ikL http://localhost:30500"
curl -ikL http://localhost:30500/
echo "Test app on fixed nodePort with: curl -ikL http://localhost:30500/health"
curl -ikL http://localhost:30500/health

echo "Helm chart deployment was successful"
echo "When finishing your local manual tests, please delete the deployment: helm delete $HELM_APP"
