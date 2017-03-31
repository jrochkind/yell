pipeline {
  agent {
    docker 'ruby'
  }

  stages {
    stage('Build') {
      steps {
        sh 'bundle install'
      }
    }

    stage('Test') {
      steps {
        sh 'bundle exec rspec'
      }
    }
  }
}
