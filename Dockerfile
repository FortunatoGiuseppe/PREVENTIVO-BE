# Use an official Maven image with OpenJDK 17
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file and download project dependencies
COPY pom.xml /app/
RUN mvn dependency:go-offline

# Copy the rest of the project and compile the package
COPY src /app/src
RUN mvn package -DskipTests

# Second stage: create a lighter image with only the JRE
FROM openjdk:17-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the previous build stage
COPY --from=build /app/target/PREVENTIVO-BE-0.0.1-SNAPSHOT.jar /app/PREVENTIVO-BE.jar

# Expose the port on which the application will run
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "/app/PREVENTIVO-BE.jar"]

USER 10002
