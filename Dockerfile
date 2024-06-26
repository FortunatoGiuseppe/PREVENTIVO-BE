FROM maven:3.8.4-openjdk-21 AS build
WORKDIR /app

COPY pom.xml /app/
RUN mvn dependency:go-offline

COPY src /app/src
RUN mvn package -DskipTests

COPY --from=build /app/target/PREVENTIVO-BE-0.0.1-SNAPSHOT.jar /app/PREVENTIVO-BE.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/PREVENTIVO-BE.jar"]

USER 10001
