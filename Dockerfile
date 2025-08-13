#Build stage: compile and package WAR
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

#Cache dependencies for faster builds
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline

#Build the project
COPY . .
RUN mvn -q -DskipTests clean package

#Runtime stage: run WAR on embedded Tomcat (Webapp Runner)
FROM eclipse-temurin:17-jre
WORKDIR /app

#Download Webapp Runner (Tomcat 9.x compatible)
ENV WEBAPP_RUNNER_VERSION=9.0.56.0
ADD https://repo1.maven.org/maven2/com/heroku/webapp-runner/${WEBAPP_RUNNER_VERSION}/webapp-runner-${WEBAPP_RUNNER_VERSION}.jar /app/webapp-runner.jar

#Copy built WAR
COPY --from=build /app/target/*.war /app/app.war

#Render provides PORT at runtime; expose 8080 inside the container
ENV PORT=8080
EXPOSE 8080

#Start the webapp on the assigned port
CMD ["sh", "-c", "java -jar /app/webapp-runner.jar --port $PORT /app/app.war"]