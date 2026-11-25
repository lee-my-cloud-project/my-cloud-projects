terraform {
  # 조직 지정  
  cloud {
    organization = "Lee-personal-project"

    # TFC Workspace 생성
    workspaces{
      name = "2026NovProject-bluegreendeploy-bootstrap"
    }
  }
}