pipeline {
    agent {
        node {
            label 'maven-slave'
            jdk 'JDK 17'
        }
    }
    stages {
        stage('Build') {
            steps {
                script {
                    env.JAVA_HOME = "${tool 'JDK 17'}"
                    env.PATH="${env.JAVA_HOME}/bin:${env.PATH}"
                }
                sh 'java -version'
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'ahmed-sonarscanner'
            }
            steps {
                withSonarQubeEnv('ahmed-sonarqubeserver') { 
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
