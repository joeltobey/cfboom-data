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
  output="false"
{
  property name="modelTemplate" inject="ModelTemplate@cfboomJdbc";
  property name="generatedDaoTemplate" inject="GeneratedDaoTemplate@cfboomJdbc";
  property name="daoTemplate" inject="DaoTemplate@cfboomJdbc";
  property name="generatedServiceTemplate" inject="GeneratedServiceTemplate@cfboomJdbc";
  property name="serviceTemplate" inject="ServiceTemplate@cfboomJdbc";

  public void function generate( struct settings, string dsn, struct datasource, struct object, query fields ) {
    // Model Path
    var modelPath = settings.modelPath & "/" & dsn & "/";
    arguments.settings['modelPackage'] = left(modelPath, 1) == "/" ? replace(modelPath.substring(1), "/", ".", "all") : replace(modelPath, "/", ".", "all");
    modelPath = expandPath( modelPath );
    if ( !directoryExists(modelPath) )
      directoryCreate( modelPath );

    // Generated Path
    /*var generatedPath = settings.generatedPath & "/" & dsn & "/";
    arguments.settings['generatedPackage'] = left(generatedPath, 1) == "/" ? replace(generatedPath.substring(1), "/", ".", "all") : replace(generatedPath, "/", ".", "all");
    var generatedPath = expandPath( generatedPath );
    if ( !directoryExists(generatedPath) )
      directoryCreate( generatedPath );*/

    // Generate the files
    writeModel( argumentCollection:arguments );
    //writeGeneratedDao( argumentCollection:arguments );
    writeDao( argumentCollection:arguments );
    //writeGeneratedService( argumentCollection:arguments );
    writeService( argumentCollection:arguments );
  }

  private void function writeModel( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var filePath = expandPath( settings.modelPath & "/" & dsn & "/" & object.TABLE_NAME & ".cfc" );
    if ( !fileExists( filePath ) ) {
      var data = modelTemplate.getData( argumentCollection:arguments );
      fileWrite( filePath, data, "utf-8" );
    }
  }

  private void function writeGeneratedDao( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var filePath = expandPath( settings.generatedPath & "/" & dsn & "/" & object.TABLE_NAME & "Dao.cfc" );
    var data = generatedDaoTemplate.getData( argumentCollection:arguments );
    fileWrite( filePath, data, "utf-8" );
  }

  private void function writeDao( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var filePath = expandPath( settings.modelPath & "/" & dsn & "/" & object.TABLE_NAME & "Dao.cfc" );
    if ( !fileExists( filePath ) ) {
      var data = daoTemplate.getData( argumentCollection:arguments );
      fileWrite( filePath, data, "utf-8" );
    }
  }

  private void function writeGeneratedService( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var filePath = expandPath( settings.generatedPath & "/" & dsn & "/" & object.TABLE_NAME & "Service.cfc" );
    var data = generatedServiceTemplate.getData( argumentCollection:arguments );
    fileWrite( filePath, data, "utf-8" );
  }

  private void function writeService( struct settings, string dsn, struct datasource, struct object, query fields ) {
    var filePath = expandPath( settings.modelPath & "/" & dsn & "/" & object.TABLE_NAME & "Service.cfc" );
    if ( !fileExists( filePath ) ) {
      var data = serviceTemplate.getData( argumentCollection:arguments );
      fileWrite( filePath, data, "utf-8" );
    }
  }
}
