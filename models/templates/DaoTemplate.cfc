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
      .append(" * ").append( object.TABLE_NAME ).append(" Data Access Object").append( NEW_LINE )
      .append(" */").append( NEW_LINE )
      .append("component").append( NEW_LINE )
      .append( TAB ).append('extends="cfboom.jdbc.models.AbstractQuerySupport"').append( NEW_LINE)
      .append( TAB ).append('displayname="Class ').append( object.TABLE_NAME ).append('Dao"').append( NEW_LINE )
      .append( TAB ).append('output="false"').append( NEW_LINE)
      .append("{").append( NEW_LINE );

    // Init
    sb.append( TAB ).append("/**").append( NEW_LINE )
      .append( TAB ).append(" * @datasource.inject coldbox:datasource:").append( dsn ).append( NEW_LINE )
      .append( TAB ).append(" */").append( NEW_LINE )
      .append( TAB ).append("public ").append( settings.modelPackage ).append( object.TABLE_NAME ).append("Dao function init( required struct datasource ) {").append( NEW_LINE )
      .append( TAB ).append( TAB ).append('super.init( arguments.datasource, "').append( dsn ).append(".").append( object.TABLE_NAME ).append('" );').append( NEW_LINE )
      .append( TAB ).append( TAB ).append("return this;").append( NEW_LINE )
      .append( TAB ).append("}").append( NEW_LINE )
      .append( NEW_LINE );

    sb.append("}").append( NEW_LINE );

    return sb.toString();
  }
}
