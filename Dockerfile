FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY . .
RUN mvn -q -DskipTests clean package

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat
COPY conf/server.xml conf/server.xml
RUN rm -rf webapps/ROOT
COPY --from=build /app/target/*.war webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]