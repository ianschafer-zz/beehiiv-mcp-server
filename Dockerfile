FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests && ls -la target/

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*SNAPSHOT.jar app.jar
RUN ls -la /app/
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
