/*
 * Copyright 2016 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Builds MySQL statements
 *
 * @singleton
 */
component
  displayname="Class MysqlBuilder"
  output="false"
{
  public cfboom.jdbc.models.sql.MysqlBuilder function init() {
    return this;
  }

  public string function findAllWhere( required cfboom.jdbc.models.Object object, required struct params, string sortOrder = "" ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("SELECT * FROM `")
      .append( object.getTable() )
      .append("`");

    var firstKey = true;

    // Loop through params
    for ( var key in params ) {
      var field = object.getFieldMap()[key];
      if ( firstKey ) {
        sb.append(" WHERE `");
      } else {
        sb.append(" AND `");
      }
      firstKey = false;

      // Column name
      sb.append( field.getColumn() )
        .append("`");

      // Determine filter
      if (structKeyExists(params[key], "Value") && !structKeyExists(params[key], "Mod")) {
        sb.append(" = :").append( field.getName() );
      } else if (!structKeyExists(params[key], "Value") && structKeyExists(params[key], "Mod")) {
        if (params[key].Mod == "isnull") {
          sb.append(" IS NULL");
        } else if (params[key].Mod == "isnotnull") {
          sb.append(" IS NOT NULL");
        }
      } else {
        if (params[key].Mod == "lt") {
          sb.append("` < :").append( field.getName() );
        } else if (params[key].Mod == "gt") {
          sb.append("` > :").append( field.getName() );
        } else if (params[key].Mod == "lte") {
          sb.append("` <= :").append( field.getName() );
        } else if (params[key].Mod == "gte") {
          sb.append("` >= :").append( field.getName() );
        } else if (params[key].Mod == "neq") {
          sb.append("` != :").append( field.getName() );
        } else if (params[key].Mod == "between") {
          sb.append("` BETWEEN :").append( field.getName() ).append(" AND :").append( field.getName() ).append("_Range");
        } else if (params[key].Mod == "notbetween") {
          sb.append("` NOT BETWEEN :").append( field.getName() ).append(" AND :").append( field.getName() ).append("_Range");
        } else if (params[key].Mod == "contains") {
          sb.append("` COLLATE utf8_bin LIKE :").append( field.getName() );
        } else if (params[key].Mod == "cicontains") {
          sb.append("` LIKE :").append( field.getName() );
        } else if (params[key].Mod == "in") {
          sb.append("` IN (:").append( field.getName() ).append(")");
        } else if (params[key].Mod == "notin") {
          sb.append("` NOT IN (:").append( field.getName() ).append(")");
        }
      }
    }

    if (len(sortOrder)) {
      sb.appned(" ORDER BY `").append( sortOrder ).append("`");
    }
    return sb.toString();
  }

  public string function new( required cfboom.jdbc.models.Object object, required struct criteria ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("INSERT INTO `")
      .append( object.getTable() )
      .append("` ");

    var fieldList = createObject("java", "java.lang.StringBuilder").init();
    var paramList = createObject("java", "java.lang.StringBuilder").init();

    var firstKey = true;
    for ( var key in criteria ) {
      if ( !structKeyExists(object.getFieldMap(), key) )
        throw("Unknown field `" & key & "` in new() criteria", "SqlBuilderException");

      var field = object.getFieldMap()[key];
      if ( !firstKey ) {
        fieldList.append(", ");
        paramList.append(", ");
      }
      fieldList.append("`").append( field.getColumn() ).append("`");
      if (field.getFieldType() == "timestamp" && criteria[key] == "UTC_TIMESTAMP") {
        paramList.append("UTC_TIMESTAMP");
      } else {
        paramList.append(":").append( field.getName() );
      }

      firstKey = false;
    }

    sb.append("(").append( fieldList ).append(") VALUES (").append( paramList ).append(");");
    return sb.toString();
  }

  public string function update( required cfboom.jdbc.models.Object object, required cfboom.jdbc.models.Field idField, required struct criteria ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("UPDATE `")
      .append( object.getTable() )
      .append("` SET");

    var firstKey = true;
    for ( var key in criteria ) {
      if ( !structKeyExists(object.getFieldMap(), key) )
        throw("Unknown field `" & key & "` in update() criteria", "SqlBuilderException");

      var field = object.getFieldMap()[key];
      if ( !firstKey )
        sb.append(", ");

      sb.append("`").append( field.getColumn() ).append("` = ");
      if (field.getFieldType() == "timestamp" && criteria[key] == "UTC_TIMESTAMP") {
        sb.append("UTC_TIMESTAMP");
      } else {
        sb.append(":").append( field.getName() );
      }

      firstKey = false;
    }

    sb.append(" WHERE `").append( idField.getColumn() ).append("` = :").append( idField.getName() );
    return sb.toString();
  }

}
