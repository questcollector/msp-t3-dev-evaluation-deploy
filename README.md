# evaluation infrastructure as Code with terraform

## 환경 설정

### 1. aws cli 설치

최신 버전의 aws cli를 운영체제에 맞는 방법으로 설치합니다.

https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html

aws configure를 설정하여 access key와 secret access key를 등록합니다.

```shell
aws configure
```

### 2. terraform 설치

최신 버전의 terraform을 운영체제에 맞는 방법으로 설치합니다.

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### 3. git clone

최신 버전의 git을 운영체제에 맞는 방법으로 설치합니다.

https://git-scm.com/downloads

다음 명령어로 이 Repository를 clone 합니다.

```shell
git clone 
```

## terraform apply

clone한 repository의 경로에서 `provider.tf`를 수정합니다.

`terraform.tfstate` 파일이 저장될 s3 bucket은 사전에 준비합니다.

준비되지 않았다면 backend 블럭을 모두 `#` 기호로 주석처리 합니다.

```json
terraform {
  backend "s3" {
    bucket  = "state file이 저장될 s3 bucket명"
    key     = "evaluation/terraform.tfstate"
    region  = "버킷의 위치"
    encrypt = true
  }
  required_version = ">=1.1.3"
}
provider "aws" {
  region = var.aws_region
}

```

terraform.tfvars 파일에 적절한 값으로 수정합니다.

```json
aws_region          = "자원이 생성될 리전"             # "ap-northeast-1"
my_ami              = "docker 인스턴스의 ami(ubuntu 22.04 free tier)" # "ami-088da9557aae42f39"
global_lounge_cidr = ["실습강사 IP CIDR", ...]
```

다음 명령어로 terraform 코드가 유효한지 확인합니다.

```shell
terraform validate
```

다음 명령어로 생성될 자원을 확인합니다.

```shell
terraform plan
```

오류와 특별한 이상이 없다면 다음 명령어로 자원을 생성합니다.

slack_token 변수에는 slack bot user token을 입력합니다.

```shell
terraform apply --auto-approve
```

### stack 확인하기

AWS console > EC2 > instances > evaluation-docker-server에서

connect 버튼을 클릭한 후 Session Manager 탭에서 connect 버튼을 클릭하면 인스턴스에 연결할 수 있습니다.

다음 명령어로 stack에 올라온 서비스들을 확인할 수 있습니다.

```shell
sudo docker stack services msp-t3
```

다음 명령어로 전체 container의 정보를 확인할 수 있습니다.

```shell
sudo docker ps
```

다음 명령어로 서비스의 log를 확인할 수 있습니다.

```shell
sudo docker service logs <<service_name>>
```

AWS cloudwatch log group 중 msp-t3-dev-evaluation 로그 그룹에서도 컨테이너별로 로그를 확인할 수 있습니다.
