# First stage: Use an official Maven image with OpenJDK 17 for building the application
FROM maven:3.8.4-openjdk-22 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file and download project dependencies
COPY pom.xml /app/
RUN mvn dependency:go-offline

# Copy the rest of the project and compile the package
COPY src /app/src
RUN mvn package -DskipTests

# Second stage: Use an official OpenJDK runtime image
FROM openjdk:22-jdk

# Set the working directory
WORKDIR /app

# Copy the JAR file from the previous build stage
COPY --from=build /app/target/PREVENTIVO-BE-0.0.1-SNAPSHOT.jar /app/PREVENTIVO-BE.jar

# Expose the port on which the application will run
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "/app/PREVENTIVO-BE.jar"]

# Use a non-root user
USER 10001
