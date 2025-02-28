#
# Build stage
#
FROM maven:3.9.6-amazoncorretto-21 AS build

WORKDIR /ecommerce-system

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

#
# Package stage
#
FROM amazoncorretto:21-alpine-jdk

WORKDIR /ecommerce-system

COPY --from=build /ecommerce-system/target/*.jar ./ecommerce-registry-server.jar

EXPOSE 7070

ENTRYPOINT ["java","-jar","ecommerce-registry-server.jar"]