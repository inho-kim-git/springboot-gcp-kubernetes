## Openjdk 11 기본 베이스 이미지
FROM adoptopenjdk/openjdk11:jre-11.0.7_10-alpine

# 홈 디렉토리 설정
ENV APP_HOME /app
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/config
WORKDIR $APP_HOME

# 포트 80 노출
EXPOSE 80

# Google Application Credential 파일 설정 (서비스 운영 시에 필요)
# COPY build/resources/main/gcp_service_account.json $APP_HOME/config/gcp_service_account.json
# ENV GOOGLE_APPLICATION_CREDENTIALS $APP_HOME/config/gcp_service_account.json

# Jar 파일 복사
COPY build/libs/google-v1.jar application.jar

# 실행 환경 설정
ENV JAVA_OPTS="-Dspring.profiles.active=test -Djava.security.edg=file:/test/./urandom -Dfile.encoding=UTF-8"

# 컨테이너 실행 시 어플리케이션 실행
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar application.jar"]