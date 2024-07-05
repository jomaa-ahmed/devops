pipeline {
    agent {
        node {
            label 'maven'
        }    
    }

    stages {
        stage('Clone Code from git') {
            steps {
                git branch: 'main', url: 'https://github.com/jomaa-ahmed/devopsCICD.git'
            }
        }
    }
}
