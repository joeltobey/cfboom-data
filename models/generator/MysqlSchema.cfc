/**
 * Created by joeltobey on 4/15/17.
 */
component
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
