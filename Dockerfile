# Використовуємо офіційний образ PostgreSQL
FROM postgres:latest

# Встановлення змінних середовища для бази даних
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=online_store

# Копіюємо SQL-файли у контейнер
COPY ./create_tables.sql /docker-entrypoint-initdb.d/1_create_tables.sql
COPY ./insert_data.sql /docker-entrypoint-initdb.d/2_insert_data.sql
COPY ./functions_procedures.sql /docker-entrypoint-initdb.d/3_functions_procedures.sql
COPY ./triggers.sql /docker-entrypoint-initdb.d/4_triggers.sql
COPY ./views.sql /docker-entrypoint-initdb.d/5_views.sql
