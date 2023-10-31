FROM maven:3.8.5-openjdk-17 as build

WORKDIR /app

COPY .mvn/ .mvn
COPY src/ src 
COPY pom.xml mvnw  ./

ENV MAVEN_CONFIG=""

RUN mvn clean package -Dmaven.test.skip=true

# Final image
FROM eclipse-temurin:17.0.8.1_1-jre

# app port
EXPOSE 8080
# metrics port
EXPOSE 8088

WORKDIR /app
COPY --from=build /app/target/spring-petclinic-*.jar spring-petclinic.jar
COPY jmx-config.yml jmx-config.yml

# downloads jmx exporter jar
RUN wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar

ENV RUN_PROFILE="dev"
ENTRYPOINT java -javaagent:/app/jmx_prometheus_javaagent-0.19.0.jar=8088:/app/jmx-config.yml -jar /app/spring-petclinic.jar --spring.profiles.active="${RUN_PROFILE}"

