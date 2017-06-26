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
 *
 */
component
  extends="coldbox.system.FrameworkSupertype"
{
  // Module Properties
  this.title              = "cfboom JDBC Service";
  this.author             = "Joel Tobey";
  this.webURL             = "https://github.com/joeltobey/cfboom-jdbc";
  this.description        = "This JDBC Service provides an easy ORM-like approach to your data.";
  this.version            = "0.5.0";
  // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
  this.viewParentLookup   = true;
  // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
  this.layoutParentLookup = true;
  // Module Entry Point
  this.entryPoint         = "cfboom/jdbc";
  // Model Namespace
  this.modelNamespace     = "cfboomJdbc";
  // CF Mapping
  this.cfmapping          = "cfboom/jdbc";
  // Auto-map models
  this.autoMapModels      = true;
  // Module Dependencies
  this.dependencies       = [];

  function configure() {

    // module settings - stored in modules.name.settings
    settings = {
      // Array of datasources that the cfboom-jdbc module manages
      datasources = [],

      // Set to 'false' for Production
      generateModel = false,
      generatedPath = "/generated",
      modelPath = "/models"
    };

  }

  /**
   * Fired when the module is registered and activated.
   */
  function onLoad() {
    if ( settings.generateModel ) {
      for ( var dsn in settings.datasources ) {
        var datasource = getDatasource( dsn );
        var objects = getModel( "MysqlSchema@cfboomJdbc" ).getObjects( datasource.name, datasource.schema );
        for ( var object in objects ) {
          var fields = getModel( "MysqlSchema@cfboomJdbc" ).getFields( datasource.name, datasource.schema, object.TABLE_NAME );
          getModel( "Generator@cfboomJdbc" ).generate( settings, dsn, datasource, object, fields );
        }
      }
    }
  }

  /**
   * Fired when the module is unregistered and unloaded
   */
  function onUnload() {

  }

}
