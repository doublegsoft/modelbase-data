<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${cpp.license(license)}
</#if>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>

#include "DataStorage.hpp"

void DataStorage::Open(std::string& databasePath)
{
  this->databasePath = databasePath;
  this->database = QSqlDatabase::addDatabase("QSQLITE");

  this->database.setDatabaseName(databasePath);
  this->database.open()
}

void DataStorage::Close()
{

}