<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${cpp.license(license)}
</#if>
#pragma once

#include <string>
#include <QSqlDatabase>

class DataStorage {

public:

  /*!
  ** Opens data storage engine.
  */
  void Open(std::string& filepath);

  /*!
  ** Closes data storage engine.
  */
  void Close();
<#list model.objects as obj>

  /*!
  ** Saves a ${obj.name} object.
  */

  /*!
  ** Removes a ${obj.name} object.
  */

  /*!
  ** Finds a ${obj.name} object.
  */
</#list>

private:

  QSqlDatabase    database;

  std::string     databasePath;

};