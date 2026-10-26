# Этап 1: сборка WAR через Maven
FROM maven:3.8-openjdk-11 AS buildMaven
WORKDIR /myApp                   # <-- обязательно: задаём рабочую папку

COPY pom.xml .
COPY src ./src

# Собираем WAR (пропускаем тесты для скорости)
RUN mvn package -DskipTests

# Этап 2: финальный образ с Tomcat
FROM tomcat:9.0-jdk11-openjdk

# Отладка: посмотрим, что лежит в target на этапе сборки
RUN ls -la /myApp/target

# Копируем собранный WAR из этапа build.
COPY --from=buildMaven /myApp/target/hello-1.0.war /usr/local/tomcat/webapps/hello-1.0.war

EXPOSE 8080