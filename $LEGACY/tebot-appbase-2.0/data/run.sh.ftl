mysql -u root -p ${app.name}_test < ./sql/install-database-${app.name}-mysql.sql

mysql -u root -p ${app.name}_test < ./sql/setup-testdata-${app.name}-mysql.sql
