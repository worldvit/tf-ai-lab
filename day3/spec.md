# 요구사항 명세 — 3계층 웹 서비스 (ALB + Auto Scaling + RDS)

## 맥락
- Terraform 1.17, AWS Provider 6.x, 리전 ap-northeast-2
- versions.tf·backend.tf는 이미 있다. provider·terraform·backend 블록은 쓰지 않는다
- 파일은 network.tf, alb.tf, asg.tf, rds.tf, variables.tf, outputs.tf 로 나눈다

## 네트워크
- VPC 10.70.0.0/16, AZ 2개(데이터 소스), AZ마다 퍼블릭 1개·프라이빗 1개 서브넷 (for_each, 키는 AZ 이름)
- 퍼블릭만 인터넷 게이트웨이로 나간다. NAT 게이트웨이는 만들지 않는다(비용)
- 프라이빗 서버가 패키지를 받을 수 있게 S3 게이트웨이 엔드포인트를 프라이빗 라우팅 테이블에 붙인다

## 웹 계층
- 인터넷용 ALB(퍼블릭 서브넷 2개), HTTP 80 리스너, 대상 그룹 헬스 체크 경로 /
- Auto Scaling 그룹: 프라이빗 서브넷 2개, 최소·최대·희망 2대, 헬스 체크 ELB
- 시작 템플릿: Amazon Linux 2023 최신 AMI(SSM 파라미터), t3.micro, IMDSv2 필수, 루트 볼륨 암호화
- user_data: nginx 설치, 첫 페이지에 "<h1>tfai-d3</h1><p>호스트 이름</p>"
- 서버 보안 그룹은 ALB 보안 그룹에서 오는 80번만 허용

## 데이터 계층
- RDS MySQL 8.4, db.t4g.micro, 20GB gp3, 단일 AZ, 프라이빗 서브넷 그룹
- 퍼블릭 접근 금지, 저장 암호화, DB 보안 그룹은 서버 보안 그룹에서 오는 3306만 허용
- 관리자 비밀번호는 sensitive 변수 db_password로 받는다(코드에 쓰지 않음)
- 실습용: 삭제 보호 끔, 최종 스냅샷 건너뜀

## 출력
- alb_url (http://DNS 이름), db_endpoint

## 보안 기본값
- 보안 그룹 규칙은 aws_vpc_security_group_ingress_rule / egress_rule 리소스로
- 0.0.0.0/0 인바운드는 ALB 80번만
