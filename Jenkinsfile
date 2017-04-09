node {
  checkout scm

  stage 'Build'
  sh 'bundle install'

  stage 'Test'
  sh 'bundle exec rspec'
}
