pipeline {
    agent any

    stages {
        stage('Syntax') {
            steps {
                sh 'pwd'
                sh 'ls -l'
                sh 'sh syntax.sh'
                sh '$WORKSPACE/syntax.sh'
                sh './syntax.sh'
            }
        }

        stage('Archive') {
            steps {
                sh 'mkdir -p artifacts && git archive -o artifacts/sharpmod-SNAPSHOT.zip --prefix=SharpMod/ -9 HEAD'
                archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
            }
        }
    }
}
