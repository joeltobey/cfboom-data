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

  public string function findWhere( required cfboom.jdbc.models.Object object, required struct criteria ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("SELECT * FROM `")
      .append( object.getTable() )
      .append("`");

    var firstKey = true;
    for ( var key in criteria ) {
      if ( !structKeyExists(object.getFieldMap(), key) )
        throw("Unknown field `" & key & "` in findWhere() criteria", "SqlBuilderException");

      var field = object.getFieldMap()[key];
      if ( firstKey ) {
        sb.append(" WHERE `");
      } else {
        sb.append(" AND `");
      }
      sb.append( field.getColumn() )
        .append("` = :")
        .append( field.getName() );

      firstKey = false;
    }
    return sb.toString();
  }
}
