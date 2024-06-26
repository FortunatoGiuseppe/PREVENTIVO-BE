# Utilizza una immagine di base ufficiale di Maven con OpenJDK 22
FROM maven:3.8.4-openjdk-22 AS build

# Setta la directory di lavoro
WORKDIR /app

# Copia il file pom.xml e scarica le dipendenze del progetto
COPY pom.xml /app/
RUN mvn dependency:go-offline

# Copia il resto del progetto e compila il package dell'applicazione
COPY src /app/src
RUN mvn package -DskipTests

# Seconda fase: crea una immagine più leggera con solo JRE
FROM openjdk:22-jre

# Setta la directory di lavoro
WORKDIR /app

# Copia il file JAR dal contesto di build precedente
COPY --from=build /app/target/PREVENTIVO-BE-0.0.1-SNAPSHOT.jar /app/PREVENTIVO-BE.jar

# Espone la porta su cui l'applicazione sarà in esecuzione
EXPOSE 8080

# Definisce il comando per eseguire l'applicazione
CMD ["java", "-jar", "/app/PREVENTIVO-BE.jar"]

USER 10001