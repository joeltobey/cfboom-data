/**
 * Created by joeltobey on 4/15/17.
 */
component
  output="false"
{
  TAB = createObject("java", "java.lang.StringBuilder").init(" ").append(" ");
  NEW_LINE = createObject("java", "java.lang.StringBuilder").init( createObject("java", "java.lang.System").lineSeparator() );

  private string function convertColumnNameToProperyName(required string name) {
    var convertedName = "";
    var firstLetter = "";
    name = replace(name, "__c", "");
    var snakeCaseArray = listToArray(name, "_");
    for ( var snake in snakeCaseArray ) {
      firstLetter = left(snake, 1);
      convertedName &= uCase(firstLetter) & snake.substring(1);
    }
    firstLetter = left(convertedName, 1);
    convertedName = lCase(firstLetter) & convertedName.substring(1);
    return convertedName;
  }

  private string function translateToColdFusionType(required string type) {
    switch( type ) {
      case "year": case "date": case "datetime": case "timestamp": case "time":
        return "date";
        break;

      case "tinyint": case "smallint": case "mediumint": case "int": case "bigint":
      case "double": case "decimal": case "float":
        return "numeric";
        break;

      case "binary": case "varbinary":
        return "binary";
        break;

      case "bit":
        return "boolean";
        break;

      case "tinytext": case "mediumtext": case "text": case "longtext":
      case "tinyblob": case "mediumblob": case "blob": case "longblog":
      case "char": case "varchar": case "enum":
        return "string";
        break;

      default:
        throw("Unhandled datatype [#type#]");
    }
  }

  private string function translateToColdFusionSqlType(required string type) {
    switch( type ) {
      case "year": case "date":
        return "cf_sql_date";
        break;

      case "datetime": case "timestamp":
        return "cf_sql_timestamp";
        break;

      case "time":
        return "cf_sql_time";
        break;

      case "tinyint":
        return "cf_sql_tinyint";
        break;

      case "smallint":
        return "cf_sql_smallint";
        break;

      case "mediumint": case "int":
        return "cf_sql_integer";
        break;

      case "bigint":
        return "cf_sql_bigint";
        break;

      case "double":
        return "cf_sql_double";
        break;

      case "decimal":
        return "cf_sql_decimal";
        break;

      case "float":
        return "cf_sql_float";
        break;

      case "binary":
        return "cf_sql_binary";
        break;

      case "varbinary":
        return "cf_sql_varbinary";
        break;

      case "bit":
        return "cf_sql_bit";
        break;

      case "char":
        return "cf_sql_char";
        break;

      case "varchar": case "tinytext": case "enum":
        return "cf_sql_varchar";
        break;

      case "mediumtext": case "text": case "longtext":
        return "cf_sql_longvarchar";
        break;

      case "tinyblob": case "mediumblob": case "blob": case "longblog":
        return "cf_sql_blob";
        break;

      default:
        throw("Unhandled datatype [#type#]");
    }
  }
}
