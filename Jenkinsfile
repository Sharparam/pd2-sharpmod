pipeline {
    agent any

    stages {
        stage('Archive') {
            steps {
                sh 'mkdir -p artifacts && git archive -o artifacts/sharpmod-SNAPSHOT.zip --prefix=SharpMod/ -9 HEAD'
                archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
            }
        }
    }
}
