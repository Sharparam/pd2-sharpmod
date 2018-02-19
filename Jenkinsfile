pipeline {
    agent any

    stages {
        stage('Package') {
            steps {
                sh 'mkdir artifacts && git archive -o artifacts/sharpmod-snapshot.zip --prefix=SharpMod/ -9 HEAD'
                archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
            }
        }
    }
}
