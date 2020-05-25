podTemplate(label: 'mypod', serviceAccount: 'jenkins-ci', containers: [ 
    containerTemplate(
      name: 'docker', 
      image: 'docker', 
      command: 'cat', 
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'kubectl', 
      image: 'amaceog/kubectl',
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi', 
      ttyEnabled: true, 
      command: 'cat'
    ),
    containerTemplate(
      name: 'helm', 
      image: 'alpine/helm:2.14.0', 
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true, 
      command: 'cat'
    )
  ],

  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    // hostPathVolume(mountPath: '/usr/local/bin/helm', hostPath: '/usr/local/bin/helm')
  ]
  ) {
    node('mypod') {

        def REPOSITORY_URI = "gcr.io/k8majutest/phpapp"
        def HELM_APP_NAME = "php-app"
        def HELM_CHART_DIRECTORY = "k8s/app"

        stage('Get latest version of code') {
          checkout scm
        }
        stage('Check running containers') {
            container('docker') {  
                sh 'hostname'
                sh 'hostname -i' 
                sh 'docker ps'
                sh 'ls'
            }
            container('kubectl') { 
                sh 'kubectl get pods -n default'  
            }
            container('helm') { 
                sh 'helm init --client-only --skip-refresh'
                sh 'helm repo update'     
            }
        }  

        stage('Build Image'){
            container('docker'){

        withCredentials([file(credentialsId: 'gcrjson', variable: 'DOCKER_REPO_KEY_PATH')]) {
                sh 'docker login -u _json_key --password-stdin https://gcr.io/k8majutest < ${DOCKER_REPO_KEY_PATH}'

                sh "docker build -t ${REPOSITORY_URI}:${BUILD_NUMBER} ./docker"
                sh 'docker image ls' 
                
                
                        }
              // withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
              //   sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
              //   sh "docker build -t ${REPOSITORY_URI}:${BUILD_NUMBER} ./docker"
              //   sh 'docker image ls' 
              // } 
                
            }
        } 

        stage('Testing') {
            container('docker') { 
              sh 'whoami'
              sh 'hostname -i' 
              // sh "docker run ${REPOSITORY_URI}:${BUILD_NUMBER} npm run test "                 
            }
        }

        stage('Push Image'){
            container('docker'){
        withCredentials([file(credentialsId: 'gcrjson', variable: 'DOCKER_REPO_KEY_PATH')]) {
                sh "docker login -u _json_key --password-stdin https://gcr.io/k8majutest < ${DOCKER_REPO_KEY_PATH} \
                 && docker push ${REPOSITORY_URI}:${BUILD_NUMBER}"
              }                 
            }
        }

        stage('Deploy Image to k8s'){
            container('helm'){
            sh 'helm list'
                sh "helm lint ./${HELM_CHART_DIRECTORY}"
                sh "helm upgrade --install --force --set app.image.repository=${REPOSITORY_URI} --set app.image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}"
                sh "helm list | grep ${HELM_APP_NAME}"
            }
        }      
    }
}