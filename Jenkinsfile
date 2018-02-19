pipeline {
    agent any

    stages {
        stage('Package') {
            steps {
                sh 'git archive -o artifacts/sharpmod-snapshot.zip --prefix=SharpMod/ -9 HEAD'
                archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
            }
        }
    }
}
