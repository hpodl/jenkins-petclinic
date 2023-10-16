FROM maven:3.8.5-openjdk-17

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve

COPY src ./src

ENTRYPOINT ["./mvnw", "spring-boot:run"]
