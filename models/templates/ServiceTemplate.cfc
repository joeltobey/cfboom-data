/**
 * Created by joeltobey on 4/15/17.
 */
component
  extends="cfboom.jdbc.models.templates.AbstractTemplate"
  output="false"
{
  public string function getData( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var sb = createObject("java", "java.lang.StringBuilder").init();
    sb.append("/**").append( NEW_LINE )
      .append(" * Service to handle ").append( object.TABLE_NAME ).append(" operations.").append( NEW_LINE )
      .append(" *").append( NEW_LINE )
      .append(" * @singleton").append( NEW_LINE )
      .append(" */").append( NEW_LINE );
    sb.append("component").append( NEW_LINE )
      .append( TAB ).append('displayname="Class ').append( object.TABLE_NAME ).append(' Service"').append( NEW_LINE )
      .append( TAB ).append('extends="cborm.models.VirtualEntityService"').append( NEW_LINE)
      .append( TAB ).append('accessors="true"').append( NEW_LINE)
      .append( TAB ).append('output="false"').append( NEW_LINE)
      .append("{").append( NEW_LINE )
      .append( TAB ).append("/**").append( NEW_LINE )
      .append( TAB ).append(' * @dsn.inject coldbox:datasource:').append( dsn ).append ( NEW_LINE )
      .append( TAB ).append(" */").append( NEW_LINE )
      .append( TAB ).append("public models."). append( dsn ). append(".").append( object.TABLE_NAME ).append("Service function init(required struct dsn) {").append( NEW_LINE )
      .append( TAB ).append( TAB ).append("var args = {};").append( NEW_LINE )
      .append( TAB ).append( TAB ).append("args['entityName'] = ").append('"').append( object.TABLE_NAME ).append('";').append( NEW_LINE )
      .append( TAB ).append( TAB ).append("args['queryCacheRegion'] = ").append('"').append( object.TABLE_NAME ).append('";').append( NEW_LINE )
      .append( TAB ).append( TAB ).append("args['datasource'] = dsn.name;").append( NEW_LINE )
      .append( TAB ).append( TAB ).append('super.init( argumentCollection:args );').append( NEW_LINE )
      .append( TAB ).append( TAB ).append("return this;").append ( NEW_LINE )
          .append( TAB ).append("}").append( NEW_LINE );
      sb.append("}").append( NEW_LINE )
    return sb.toString();
  }
}
