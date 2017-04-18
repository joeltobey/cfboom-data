/**
 * Created by joeltobey on 4/15/17.
 */
interface
{
  public query function getObjects(string dsn, string schema);

  public query function getFields(string dsn, string schema, string object);
}
