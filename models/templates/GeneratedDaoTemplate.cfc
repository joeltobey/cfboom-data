/*
 * Copyright 2017 Joel Tobey <joeltobey@gmail.com>
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
 * Created by joeltobey on 4/15/17.
 */
component singleton
  extends="cfboom.jdbc.models.templates.AbstractTemplate"
  output="false"
{
  public string function getData( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("/**").append( NEW_LINE )
      .append(" * DO NOT UPDATE this file; it is auto-generated and any udates will be overwritten!").append( NEW_LINE )
      .append(" * ").append( NEW_LINE )
      .append(" * Generated ").append( object.TABLE_NAME ).append(" Data Access Object").append( NEW_LINE )
      .append(" */").append( NEW_LINE )
      .append("component").append( NEW_LINE )
      .append( TAB ).append('extends="cfboom.jdbc.models.AbstractQuerySupport"').append( NEW_LINE)
      .append( TAB ).append('displayname="Generated Class ').append( object.TABLE_NAME ).append('DAO"').append( NEW_LINE )
      .append( TAB ).append('output="false"').append( NEW_LINE)
      .append("{").append( NEW_LINE );

    // Init
    sb.append( TAB ).append("public ").append( settings.generatedPackage ).append( object.TABLE_NAME ).append("Dao function init( required string datasource, required cfboom.jdbc.models.Object object, required cfboom.jdbc.models.sql.Sqlbuilder sqlBuilder ) {")
      .append( TAB ).append( TAB ).append("super.init( argumentCollection:arguments );").append( NEW_LINE )
      .append( TAB ).append( TAB ).append("return this;").append( NEW_LINE )
      .append( TAB ).append("}").append( NEW_LINE )
      .append( NEW_LINE );

    // Loop through the fields
    for ( var field in fields ) {

      // Property Comment
      if (len(field.COLUMN_COMMENT)) {
        sb.append( TAB ).append("/**").append( NEW_LINE );
        var comments = listToArray(field.COLUMN_COMMENT, NEW_LINE);
        for (var comment in comments) {
                sb.append( TAB ).append(" * ").append( comment ).append( NEW_LINE );
        }
            sb.append( TAB ).append(" */").append( NEW_LINE );
      }
// name
            sb.append( TAB ).append('property name="').append( convertColumnNameToProperyName(field.COLUMN_NAME) ).append('"');
          sb.append(' label="').append( field.COLUMN_NAME ).append('"');
// fieldType
      if ( field.COLUMN_KEY == "PRI" ) {
        sb.append(' fieldType="id" generator="native" setter="false"');
      } else if ( field.DATA_TYPE == "datetime" ) {
        sb.append(' fieldType="timestamp"');
      } else {
        sb.append(' fieldType="column"');
      }
// column
                      sb.append(' column="').append( field.COLUMN_NAME ).append('"')
// type
                  .append(' type="').append( translateToColdFusionType(field.DATA_TYPE) ).append('"')
// sqlType
            .append(' sqlType="').append( translateToColdFusionSqlType(field.DATA_TYPE) ).append('"');
      if ( field.IS_NULLABLE == "YES" )
        sb.append(' nillable="true"');
      if ( len(field.CHARACTER_MAXIMUM_LENGTH) )
            sb.append(' length="').append( javaCast("int", field.CHARACTER_MAXIMUM_LENGTH) ).append('"');
          sb.append(";").append( NEW_LINE ).append( NEW_LINE );
    } // end fields for loop
                              sb.append( TAB ).append("public models."). append( dsn ). append(".").append( object.TABLE_NAME ).append(" function init() {").append( NEW_LINE )
                  .append( TAB ).append( TAB ).append("return this;").append ( NEW_LINE )
          .append( TAB ).append("}").append( NEW_LINE );
      sb.append("}").append( NEW_LINE );
    return sb.toString();
  }
}
