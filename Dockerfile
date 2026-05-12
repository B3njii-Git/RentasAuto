# Etapa 1: Construcción
FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Etapa 2: Imagen final ligera
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/rentacar-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]