/**
 * Created by joeltobey on 4/15/17.
 */
component
  extends="cfboom.jdbc.models.templates.AbstractTemplate"
  output="false"
{
  public string function getData( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("/**").append( NEW_LINE );
    if ( len(object.TABLE_COMMENT) ) {
      var comments = listToArray(object.TABLE_COMMENT, NEW_LINE);
      for (var comment in comments) {
        sb.append(" * ").append( comment ).append( NEW_LINE );
      }
    } else {
      sb.append(" *").append( NEW_LINE );
    }
    sb.append(" */").append( NEW_LINE )
      .append("component").append( NEW_LINE )
      .append( TAB ).append('displayname="Class ').append( object.TABLE_NAME ).append('"').append( NEW_LINE )
      .append( TAB ).append('entityname="').append( object.TABLE_NAME ).append('"').append( NEW_LINE )
      .append( TAB ).append('table="').append( object.TABLE_NAME ).append('"').append( NEW_LINE )
      .append( TAB ).append('persistent="true"').append( NEW_LINE)
      .append( TAB ).append('batchsize="25"').append( NEW_LINE)
      .append( TAB ).append('cachename="').append( object.TABLE_NAME ).append('"').append( NEW_LINE )
      .append( TAB ).append('cacheuse="read-write"').append( NEW_LINE)
      .append( TAB ).append('accessors="true"').append( NEW_LINE)
      .append( TAB ).append('output="false"').append( NEW_LINE)
      .append("{").append( NEW_LINE );
    for ( var field in fields ) {
      if (len(field.COLUMN_COMMENT)) {
        sb.append( TAB ).append("/**").append( NEW_LINE );
        var comments = listToArray(field.COLUMN_COMMENT, NEW_LINE);
        for (var comment in comments) {
          sb.append( TAB ).append(" * ").append( comment ).append( NEW_LINE );
        }
        sb.append( TAB ).append(" */").append( NEW_LINE );
      }
      sb.append( TAB ).append('property name="').append( convertColumnNameToProperyName(field.COLUMN_NAME) ).append('"');
      if ( field.COLUMN_KEY == "PRI" ) {
        sb.append(' fieldtype="id" generator="native" setter="false"');
      } else if ( field.DATA_TYPE == "datetime" ) {
        sb.append(' fieldtype="timestamp"');
      } else {
        sb.append(' fieldtype="column"');
      }
      sb.append(' column="').append( field.COLUMN_NAME ).append('"')
        .append(' type="').append( translateToColdFusionType(field.DATA_TYPE) ).append('"')
        .append(' sqlType="').append( translateToColdFusionSqlType(field.DATA_TYPE) ).append('"')
        .append(";").append( NEW_LINE ).append( NEW_LINE );
    }
    sb.append( TAB ).append("public models."). append( dsn ). append(".").append( object.TABLE_NAME ).append(" function init() {").append( NEW_LINE )
      .append( TAB ).append( TAB ).append("return this;").append ( NEW_LINE )
      .append( TAB ).append("}").append( NEW_LINE );
    sb.append("}").append( NEW_LINE )
    return sb.toString();
  }
}
