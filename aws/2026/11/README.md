# 11월 프로젝트
# ECS + Route53를 활용한 Blue/Green 배포

ECS 환경에서 Blue/Green 배포를 진행하여 웹 사이트를 중단하지 않고 새로운 업데이트를 제공.

## 기술 스텍
AWS Service
- Compute: ECS, EC2
- Network: VPC, Route53
- Load Balance: ELB
- Security: IAM

CI/CD: Git, Github Action, Hashicorp Terraform Cloud
IaC: Terraform

## 설명
작업 환경을 분리하고 권한또한 분리하였기에 각 환경에 따라 작업의 세부 내용이 다릅니다.
소스코드를 사용하는 설명은 각 폴더에 존재하는 'README.md'를 읽고 진행하시기 바랍니다.

작업 순서는 'bootstrap' 에 있는 것을 먼저 진행하시기 바랍니다.