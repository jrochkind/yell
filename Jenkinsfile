pipeline {
  agent {
    docker 'ruby'
  }

  stages {
    stage('Test') {
      steps {
        sh 'bundle exec rspec'
      }
    }
  }
}
