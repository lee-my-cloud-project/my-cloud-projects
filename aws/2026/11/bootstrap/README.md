# 작업 초기 설정

## 설명
이곳에서 필요한 모든 기초 설정을 진행 합니다.

Github Action 에서 Terraform Cloud Workspace를 생성하고 이 Workspace에서 새로운 Workspace 생성 및 기초적인 AWS IAM OIDC Web Identity를 생성 합니다.

## 사용 조건
아래 조건들을 모두 만족해야 합니다.
- Github Action을 쓸 수 있도록 저장소를 이미 설정되어 있음
- Terraform Cloud에서 이미 Organization이 만들어짐
- 개발자 PC에서 적절한 권한을 가진 IAM 사용자로 로그인 된 상태

## 작업 완료 조건
Blue/Green 환경에 사용할 Workspace가 있어야 합니다.

Workspace는 지정된 저장소의 Branch에서 새로운 커밋이 있을 때 마다 VSC에서 해당 브랜치의 커밋을 받고 인프라를 업데이트 할 수 있어야 합니다.

각 Workspace는 AWS IAM OIDC Role을 사용해 각 환경을 업데이트 합니다.