# Этап 1: сборка WAR через Maven
FROM maven:3.8-openjdk-11 AS buildMaven
WORKDIR /app

COPY pom.xml .
COPY src ./src

# Собираем WAR (пропускаем тесты для скорости)
RUN mvn package -DskipTests

# Этап 2: финальный образ с Tomcat
FROM tomcat:9.0-jdk11-openjdk

# Копируем любой WAR-файл из target стадии buildMaven
COPY --from=buildMaven /app/target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080