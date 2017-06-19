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

  public any function findWhere( required struct criteria, string sortOrder = "", numeric limit = -1 ) {
    var result = findAllWhere( argumentCollection:arguments );
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

  public query function findAllWhere( required struct criteria, string sortOrder = "", numeric limit = -1 ) {
    if (len(sortOrder))
      sortOrder = getField( sortOrder ).getColumn();
    return executeQuery( _instance.sqlBuilder.findAllWhere( _instance.object, initParams(criteria), sortOrder, limit ), criteria );
  }

  public any function new( required struct criteria ) {
    var q = newQuery( _instance.sqlBuilder.new( _instance.object, criteria ) );
    for ( var key in criteria ) {
      if (_instance.object.getFieldMap()[key].getFieldType() == "timestamp" && criteria[key] == "UTC_TIMESTAMP") {
        // Do nothing
      } else {
        q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#criteria[key]#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
      }
    }
    var prefix = q.execute().getPrefix();
    if (structKeyExists(prefix, "generatedKey"))
      return prefix.generatedKey;
  }

  public void function update( required any id, required struct criteria ) {
    var idField = getIdField();
    var q = newQuery( _instance.sqlBuilder.update( _instance.object, idField, criteria ) );
    for ( var key in criteria ) {
      if (_instance.object.getFieldMap()[key].getFieldType() == "timestamp" && criteria[key] == "UTC_TIMESTAMP") {
        // Do nothing
      } else {
        q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#criteria[key]#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
      }
    }
    q.addParam(name="#idField.getName()#", value="#id#", cfsqltype="#idField.getSqlType()#");
    q.execute();
  }

  public any function executeQuery( required string statement, struct criteria ) {
    var q = newQuery( statement );
    if (structKeyExists(arguments, "criteria"))
      addParams( q, criteria );
    var result = q.execute().getResult();
    return result;
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

  public any function getIdField() {
    if (!structKeyExists(_instance, "idField")) {
      var idFieldArray = [];
      for (var field in _instance.object.getFields()) {
        if (field.getFieldType() == "id")
          arrayAppend(idFieldArray, field);
      }
      if (arrayLen(idFieldArray) == 1)
        _instance['idField'] = idFieldArray[1];
    }
    if (structKeyExists(_instance, "idField"))
      return _instance.idField;
  }

  public any function getField( required string name ) {
    if (structKeyExists(_instance.object.getFieldMap(), name))
      return _instance.object.getFieldMap()[name];
  }

  private any function newQuery( string sql ) {
    var queryService = new query();
    queryService.setDatasource( _instance.datasource );
    if (structKeyExists(arguments, "sql"))
      queryService.setSql( sql );
    return queryService;
  }

  private void function addParams( required any q, required struct criteria ) {
    var params = initParams( criteria );

    // Loop through params
    for ( var key in params ) {
      if (structKeyExists(params[key], "Value") && !structKeyExists(params[key], "Mod")) {
        q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#params[key].Value#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
      } else if (!structKeyExists(params[key], "Value") && structKeyExists(params[key], "Mod")) {
        // Do nothing. This is only for 'isnull' or 'isnotnull', which
        // are handled in the actual query.
      } else {
        if (listFindNoCase("lt,gt,lte,gte,neq", params[key].Mod)) {
          q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#params[key].Value#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
        } else if (listFindNoCase("between,notbetween", params[key].Mod)) {
          q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#params[key].Value#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
          q.addParam(name="#_instance.object.getFieldMap()[key].getName()#_Range", value="#params[key].Range#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
        } else if (listFindNoCase("contains,cicontains", params[key].Mod)) {
          q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="%#params[key].Value#%", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#");
        } else if (listFindNoCase("in,notin", params[key].Mod)) {
          q.addParam(name="#_instance.object.getFieldMap()[key].getName()#", value="#params[key].Value#", cfsqltype="#_instance.object.getFieldMap()[key].getSqlType()#", list="true", separator="|");
        }
      }
    }
  }

  private struct function initParams( required struct criteria ) {
  	var params = {};
    for ( var key in criteria ) {

      // Check is this is a modifier
      var isMod = false;
      var isRange = false;
      var fieldName = key;
      if (lCase(right(key, 4)) == "_mod") {
        isMod = true;
        fieldName = left(key, len(key) - 4);
      }
      if (lCase(right(key, 6)) == "_range") {
        isRange = true;
        fieldName = left(key, len(key) - 6);
      }

      if ( !structKeyExists(_instance.object.getFieldMap(), fieldName) )
        throw("Unknown field `" & key & "` in criteria", "SqlBuilderException");

      // Ensure param exists
      if (!structKeyExists(params, fieldName))
        params[_instance.object.getFieldMap()[fieldName].getName()] = {}; // I like correct case :)

      // Set value/modifier
      if (isMod) {
        params[fieldName]['Mod'] = criteria[key];
      } else if (isRange) {
        params[fieldName]['Range'] = criteria[key];
      } else {
        params[fieldName]['Value'] = criteria[key];
      }
    }
    return params;
  }

}
