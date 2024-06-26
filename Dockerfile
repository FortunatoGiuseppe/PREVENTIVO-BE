# Use the official Maven image as a parent image
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the POM file to download dependencies
COPY pom.xml .

# Copy the rest of the project
COPY src ./src

# Build the project using Maven
RUN mvn clean package -DskipTests

# Stage 2: Use a smaller base image for the runtime environment
FROM openjdk:17-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged JAR file from the build stage to the runtime environment
COPY --from=build /app/target/PREVENTIVO-BE-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port that the application listens to
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]

USER 10001