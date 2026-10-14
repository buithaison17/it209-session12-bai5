FROM gradle:9.7.1-jdk17-alpine as build
WORKDIR /app
COPY build.gradle settings.gradle gradlew ./
COPY gradle/ ./gradle
COPY src ./src
RUN chmod +x gradlew
RUN ./gradlew clean build bootJar --nodaemon

FROM eclipse-temurin:17-jre as run
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]