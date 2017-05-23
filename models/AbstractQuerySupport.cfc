/**
 * Created by joeltobey on 4/18/17.
 */
component
  extends="cfboom.lang.Object"
  implements="cfboom.jdbc.models.Dao"
  output="false"
{
  property name="wirebox" inject="wirebox";
  property name="populator" inject="wirebox:populator";

  /**
   * @datasource.hint The ColdFusion datasource name
   * @object.hint The object meta
   * @sqlBuilder.hint The SqlBuilder used that implements the cfboom.jdbc.models.sql.Sqlbuilder interface
   */
  public cfboom.jdbc.models.AbstractQuerySupport function init(required struct datasource,
                                                               required string beanName) {
    if (datasource.dbType != "MySQL")
      throw("cfboom JDBC does not support database type " & datasource.dbType);
    var sqlBuilder = new cfboom.jdbc.models.sql.MysqlBuilder();

    _instance['beanName'] = arguments.beanName;
    _instance['datasource'] = arguments.datasource.name;
    _instance['sqlBuilder'] = sqlBuilder;
    return this;
  }

  public any function findWhere( required struct criteria ) {
    var q = newQuery( _instance.sqlBuilder.findWhere( _instance.object, criteria ) );
    for ( var key in criteria ) {
      q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#criteria[key]#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
    }
    var result = q.execute().getResult();
    if ( result.recordCount == 1 ) {
      var args = {};
      args['target'] = wirebox.getInstance( _instance.beanName );
      args['qry'] = result;
      args['rowNumber'] = 1;
      args['trustedSetter'] = true;
      args['ignoreEmpty'] = true;
      return populator.populateFromQuery( argumentCollection=args );
    }
  }

  public void function onDIComplete() {
  	var meta = getMetadata( wirebox.getInstance( _instance.beanName ) );
    var obj = new cfboom.jdbc.models.Object();
    if (structKeyExists(meta, "label"))
      obj.setLabel( meta.label );
    if (structKeyExists(meta, "labelPlural"))
      obj.setLabelPlural( meta.labelPlural );
    if (structKeyExists(meta, "entityname"))
      obj.setName( meta.entityname );
    if (structKeyExists(meta, "table"))
      obj.setTable( meta.table );
    var fieldMap = {};
    var fields = [];
    for (var prop in meta.properties) {
      var field = new cfboom.jdbc.models.Field();
      field.setName( prop.name );
      if (structKeyExists(prop, "fieldType"))
        field.setFieldType( prop.fieldType );
      if (structKeyExists(prop, "label"))
        field.setLabel( prop.label );
      if (structKeyExists(prop, "length"))
        field.setLength( javaCast("int", prop.length) );
      if (structKeyExists(prop, "column"))
        field.setColumn( prop.column );
      if (structKeyExists(prop, "nillable") && prop.nillable == "true") {
      	field.setNillable( true );
      } else {
      	field.setNillable( false );
      }
      if (structKeyExists(prop, "sqlType"))
        field.setSqlType( prop.sqlType );
      if (structKeyExists(prop, "type"))
        field.setType( prop.type );
      fieldMap[prop.name] = field;
      arrayAppend(fields, fieldMap[prop.name]);
    }
    obj.setFields( fields );
    obj.setFieldMap( fieldMap );

    _instance['object'] = obj;
  }

  private any function newQuery( string sql ) {
    var queryService = new query();
    queryService.setDatasource( _instance.datasource );
    if (structKeyExists(arguments, "sql"))
      queryService.setSql( sql );
    return queryService;
  }
}
