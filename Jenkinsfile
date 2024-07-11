def registry = 'https://vermeg.jfrog.io'

pipeline {
    agent {
        node {
            label 'maven'
        }    
    }

    environment {
        PATH = "/opt/apache-maven-3.9.8/bin:${PATH}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer(url: "${registry}/artifactory", credentialsId: "artifact-cred")
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    
                    echo "Upload Spec: "
                    echo """{
                          "files": [
                            {
                              "pattern": "jarstaging/com/valaxy/demo-workshop/2.1.4/*",
                              "target": "libs-release-local/com/valaxy/demo-workshop/2.1.4/",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                    
                    def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/com/valaxy/demo-workshop/2.1.4/*",
                              "target": "libs-release-local/com/valaxy/demo-workshop/2.1.4/",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                    
                    try {
                        def buildInfo = server.upload(uploadSpec)
                        buildInfo.env.collect()
                        server.publishBuildInfo(buildInfo)
                        echo '<--------------- Jar Publish Ended --------------->'
                    } catch (Exception e) {
                        echo "Upload failed: ${e.message}"
                        throw e
                    }
                }
            }
        }
    }
}
