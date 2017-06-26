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
  extends="cfboom.lang.Object"
  implements="cfboom.jdbc.models.generator.Schema"
{
  public query function getObjects(string dsn, string schema) {
    var qs = new query();
    qs.setDatasource( arguments.dsn );
    qs.setSql( "SELECT * FROM `INFORMATION_SCHEMA`.`TABLES` WHERE `TABLE_SCHEMA` = :schema AND `TABLE_NAME` != 'cf_client_data';" );
    qs.addParam(name="schema", value="#arguments.schema#", cfsqltype="cf_sql_varchar");
    var result = qs.execute().getResult();
    return result;
  }

  public query function getFields(string dsn, string schema, string object) {
    var qs = new query();
    qs.setDatasource( arguments.dsn );
    qs.setSql( "SELECT * FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA` = :schema AND `TABLE_NAME` = :object" );
    qs.addParam(name="schema", value="#arguments.schema#", cfsqltype="cf_sql_varchar");
    qs.addParam(name="object", value="#arguments.object#", cfsqltype="cf_sql_varchar");
    var result = qs.execute().getResult();
    return result;
  }
}
