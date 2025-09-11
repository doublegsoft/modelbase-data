mysql -u root -p ${app.name} < ./test/sql/install-database-${app.name}-mysql.sql

mysql --force -u root -p ${app.name} < ./test/sql/setup-testdata-${app.name}-mysql.sql