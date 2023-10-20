FROM maven:3.8.5-openjdk-17 as build

WORKDIR /app

COPY .mvn/ .mvn
COPY src/ src 
COPY pom.xml mvnw  ./

ENV MAVEN_CONFIG=""

RUN mvn clean package -Dmaven.test.skip=true

# Second image
FROM eclipse-temurin:17.0.8.1_1-jre

WORKDIR /app
COPY --from=build /app/target/spring-petclinic-*.jar spring-petclinic.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]

