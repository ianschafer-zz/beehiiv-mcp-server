FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests
RUN ls -la target/

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target /tmp/jars
RUN ls -la /tmp/jars/ && \
    JAR=$(ls /tmp/jars/*.jar | grep -v plain | grep -v original | head -1) && \
    echo "Using JAR: $JAR" && \
    cp "$JAR" /app/app.jar && \
    ls -la /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", \
  "-Dspring.main.web-application-type=servlet", \
  "-Dspring.main.banner-mode=console", \
  "-Dlogging.pattern.console=%d{HH:mm:ss} %-5level - %msg%n", \
  "-Dspring.ai.mcp.server.transport=sse", \
  "-jar", "/app/app.jar"]
