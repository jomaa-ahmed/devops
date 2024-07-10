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
        
    stage('SonarQube analysis') {
    environment {
      scannerHome = tool 'ahmed-sonarscanner'
    }
    steps{
    withSonarQubeEnv('ahmed-sonarqubeserver') { 
      sh "${scannerHome}/bin/sonar-scanner"
    }
    }
    }
    }
}
