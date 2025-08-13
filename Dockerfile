FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY . .
RUN mvn -q -DskipTests clean package

FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat