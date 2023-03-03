echo '************** GET SL AGENT **********'
curl -o sealights-java-latest.zip "https://agents.sealights.co/sealights-java/sealights-java-latest.zip"
unzip -oq sealights-java-latest.zip

echo '************** GENERATE TOKEN FILE **********'
echo 'yourToken' > sltoken.txt


#echo '************** GENERATE SESSION ID **********'
#update the java process maven is starting to include the test listener java options

echo '************** SCAN BUILD **********'
echo '{
  "tokenFile": "sltoken.txt",
  "createBuildSessionId": true,
  "appName": "petclinic-be",
  "branchName": "main",
  "buildName": "1.1.0",
  "packagesIncluded": "*org.springframework.samples.petclinic.*",
  "includeResources": true,
  "executionType": "full",
  "testStage": "Unit Tests",
  "sealightsJvmParams": {
    "sl.featuresData.enableLineCoverage": "true"
  },
  "failsafeArgLine": "@{sealightsArgLine} -Dsl.testStage=\"Integration Tests\""
}' > slmaven.json
java -jar sl-build-scanner.jar -pom -configfile slmaven.json -workspacepath "."

echo '*************** BUILD & SCAN ****************'
./mvnw package 
#java -jar sl-build-scanner.jar -restore -workspacepath "."
