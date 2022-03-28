# Google Cloud PlatForm 인프라 설정
 


0. 클라우드 빌드 트리거 설정
 
- 형상관리 상에 해당 프로젝트 및 브런치와 매핑

- 빌드 구성 파일 설정 시 yml 파일 적용(이름이 반드시 일치해야함)

- 클라우드 빌드에서 트리거로 걸어둔 빌드가 제대로 동작하지 않을 때 소스나 브랜치가 제대로 업데이트 안될 경우가 있음. 이는 저장소가 제대로 동기화가 되어 있는지 확인 필요.


1. 클러스터 생성
 

- 클러스터 이름은 리소스 상의 cloudbuild yml 파일 내에 설정한 클러스터 이름과 일치해야함.

- 위치 구성은 서버에 따라 다르나 기본적으로 asia-northeast3-a 영역으로 설정.

- 마스터 버전은 디폴트로 최근 버전(항상 최신은 아님)으로 설정됨.

- 이전 버전은 구글에서 허용하지 않으므로, 업데이트에 따라 서버 설정 프로세스가 변경될 경우 구글 쪽에 문의나 추가 R&D가 필요

- 노드 풀 생성시 사용할 노드 수는 일반적으로 dev는 1개, 운영서버는 2~3개를 권장함. 서비스마다 기준 다름

- 설정 시에 하단에 나오는 내용처럼 3개 미만일 경우 노드 버전을 업그레이드 시 다운타임 발생 가능성 있으므로 참고. 
- 실질적으로 현재까지 부하가 될 만한 트래픽이 발생한 이력이 없어 운영 상에 별 지장은 없음.

- 네트워킹 설정은 설정한 VPC 망을 사용.

- 메타데이터 상에 환경 및 태그 설정(ex. env = dev(개발서버), tag = api)

2. 배포(Workload) 생성(컨테이너 + 구성)


- 신규로 생성한 클러스터 내에서 신규 배포(작업 부하) 생성

- 컨테이너는 기존 컨테이너 디폴트 (기본 엔진엑스 이미지를 사용함)

- 이미지 경로는 디폴트로 놔둠

- 차후에 최초 빌드(커밋) 시에 cloudbuild yml 파일 상에 설정된 이미지 경로로 자동 변경됨

- 구성 ui 내에서 어플리케이션 이름 설정 (cloudbuild yml 파일 상의 이름과 일치해야 함)

- 마지막 하단 클러스터가 만든 클러스터와 연동됬는지 확인 후 생성

- 생성한 배포 수정 클릭

- 아래 해당 라인을 찾으면 최초에 상위에서 설정한 디폴트 이미지 경로가 아래 image: 에 들어가고, name은 nginx-1로 되어있음. image는 차후에 자동 변경되나 컨테이너 이름은 명시적으로 수정이 필요함.

- 컨테이너 이름을 cloudbuild yml 파일에 설정된 컨테이너 이름으로 변경함.

예시)

- containers:

- image:  (자동 변경 사항)

- imagePullPolicy: Always

- name: (명시적 변경 사항)

- 상단에 작업 : 오토 스케일링에서 파드 확장 정책 설정 (최소 복제수 및 최대 복제수 설정)



3. 서비스 노출 (노드 포트로)


- 생성한 배포에 들어가 맨 하단에 노출 생성 및 포트 설정

(상단의 노출 생성도 있으나 차후 백앤드 서비스 붙을 때 문제 이력이 있어 아래 노출 버튼 클릭 사용 권장)


4. 인그레스 생성


- 서비스 및 수신 내에 3번에서 노출한 백앤드 서비스 클릭 및 상단의 인그레스 생성 버튼 클릭

- 두 번째 host 및 path 설정 부분에 3번에서 생성한 백앤드 서비스 적용

- 프론트앤드 구성 클릭

- 사용할 프로토콜 설정 시 HTTP(s) 확인

- HTTPS 설정 시에 하단에 인증서를 새로 만들어야 함.

- 인증서를 적용하는 방법은 인그레스를 새로 만들면서 같이 만들거나 만들어진 인증서를 가져다 쓰는 방법이 있음.

- 인증서를 신규로 생성시에 구글 관리형 인증서 사용(Google managed certificate)

- 인증서 내 도메인은 생성한 혹은 새로 생성할 Cloud DNS와 매핑하여 사용

- yml 설정 확인 후 인그레스 생성


- 인그레스 생성 시 함께 생성되는 항목

-- 부하 분산 (Load Balance) - 최종적으로 DNS와 인증서 잘 매핑되었는지 확인 필요

-- 고정 IP (아래 7번에서 DNS와 매핑 필요)

-- 인증서

6. 상태확인(health-check)
쿠버네티스는 인그레스 상태를 지속적으로 확인하기 때문에 헬스 체킹을 할 수 있게 경로를 정해주어야 함.

Kubernetes Engine → 서비스 및 수신으로 들어가 만든 ingress 클릭

인그레스 항목중 백엔드 서비스 항목 클릭

일반 속성중 상태 확인 항목 클릭

상태 확인에서 수정을 클릭해 health-checking을 할 URL을 입력하고 저장(default: "/")

7. 클라우드 dns에 인그래스 ip 맵핑

8. 인증서가 verify 될 때까지 기다린다 (10분에서 15분 소요)
PROVISIONING → ACTIVE
