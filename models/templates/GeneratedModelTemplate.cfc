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
    sb.append(" *").append( NEW_LINE )
      .append(" * This file is auto-generated and will be overwritten!").append( NEW_LINE )
      .append(" */").append( NEW_LINE )
      .append("component").append( NEW_LINE )
      .append( TAB ).append('extends="cfboom.lang.Object"').append( NEW_LINE )
      .append( TAB ).append('displayName="Generated Class ').append( object.TABLE_NAME ).append('"').append( NEW_LINE )
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
      sb.append( TAB ).append('property name="').append( convertColumnNameToProperyName(field.COLUMN_NAME) ).append('"')
        .append(' type="').append( translateToColdFusionType(field.DATA_TYPE) ).append('"')
        .append(' sqlType="').append( translateToColdFusionSqlType(field.DATA_TYPE) ).append('"')
    }
    sb.append("}").append( NEW_LINE )
    return sb.toString();
  }

/*
- name
- type
- sqlType
fieldType
calculated
caseSensitive
createable
defaultedOnCreate
defaultValueFormula
digits
filterable
formula
groupable
label
length
nillable
precision
scale
sortable
unique
updateable
*/
}
