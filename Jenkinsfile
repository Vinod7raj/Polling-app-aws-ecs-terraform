pipeline {
    agent any

    environment {
        AWS_REGION      = 'us-east-1'
        ECS_CLUSTER     = 'polling-ecs-cluster'
        BACKEND_ECR_REPO  = 'polling-app-server'   // just the repo name, not full URL
        FRONTEND_ECR_REPO = 'polling-app-client'
        IMAGE_TAG       = "${env.BUILD_NUMBER}"
        TF_VAR_FILE     = credentials('TR_VAR_FILE')
        REACT_APP_API_BASE_URL = 'http://polling-app.xyz/api'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ---------- INFRA ----------

        stage('Terraform Init & Plan') {
            when { changeset "terraform/**" }
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform plan -var-file=${TF_VAR_FILE} -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // manual gate before touching real infra - remove input{} once you trust the pipeline
                input message: 'Apply Terraform changes to AWS?'
                dir('terraform') {
                    sh 'terraform apply -var-file=${TF_VAR_FILE} -input=false tfplan'
                }
            }
        }

        // ---------- APP: BACKEND ----------

        stage('Build & Push Backend Image') {
            when { changeset "polling-app-server/**" }
            steps {
                script {
                    def account = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                    def registry = "${account}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${registry}
                        docker build -t ${registry}/${BACKEND_ECR_REPO}:${IMAGE_TAG} ./polling-app-server
                        docker push ${registry}/${BACKEND_ECR_REPO}:${IMAGE_TAG}
                        docker tag ${registry}/${BACKEND_ECR_REPO}:${IMAGE_TAG} ${registry}/${BACKEND_ECR_REPO}:latest
                        docker push ${registry}/${BACKEND_ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Deploy Backend to ECS') {
            when { changeset "polling-app-server/**" }
            steps {
                sh """
                    aws ecs update-service --cluster ${ECS_CLUSTER} --service backend-service --force-new-deployment --region ${AWS_REGION}
                    aws ecs wait services-stable --cluster ${ECS_CLUSTER} --services backend-service --region ${AWS_REGION}
                """
            }
        }

        // ---------- APP: FRONTEND ----------

        stage('Build & Push Frontend Image') {
            when { changeset "polling-app-client/**" }
            steps {
                script {
                    def account = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                    def registry = "${account}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${registry}
                        docker build --build-arg REACT_APP_API_BASE_URL=${REACT_APP_API_BASE_URL} -t ${registry}/${FRONTEND_ECR_REPO}:${IMAGE_TAG} ./polling-app-client
                        docker push ${registry}/${FRONTEND_ECR_REPO}:${IMAGE_TAG}
                        docker tag ${registry}/${FRONTEND_ECR_REPO}:${IMAGE_TAG} ${registry}/${FRONTEND_ECR_REPO}:latest
                        docker push ${registry}/${FRONTEND_ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Deploy Frontend to ECS') {
            when { changeset "polling-app-client/**" }
            steps {
                sh """
                    aws ecs update-service --cluster ${ECS_CLUSTER} --service frontend-service --force-new-deployment --region ${AWS_REGION}
                    aws ecs wait services-stable --cluster ${ECS_CLUSTER} --services frontend-service --region ${AWS_REGION}
                """
            }
        }
    }

    post {
        success { echo 'Pipeline completed successfully.' }
        failure { echo 'Pipeline failed - check stage logs above.' }
    }
}
