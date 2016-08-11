/*
 * Copyright 2016 Joel Tobey <joel@cfboom.com>
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
Module Directives as public properties
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- wirebox : The wirebox DSL to load and use

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)
- binder (The wirebox configuration binder)
- wirebox (The wirebox injector)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/
component {

    // Module Properties
    this.title              = "<cfboom/> Data Service";
    this.author             = "Joel Tobey";
    this.webURL             = "https://github.com/joeltobey/cfboom-data";
    this.description        = "This Data Service provides an easy ORM-like approach to your data.";
    this.version            = "1.0.0";
    // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
    this.viewParentLookup   = true;
    // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
    this.layoutParentLookup = true;
    // Module Entry Point
    this.entryPoint         = "data";
    // Model Namespace
    this.modelNamespace     = "data";
    // CF Mapping
    this.cfmapping          = "data";
    // Auto-map models
    this.autoMapModels      = true;
    // Module Dependencies
    this.dependencies       = [];

    function configure(){

        // parent settings
        parentSettings = {};

        // module settings - stored in modules.name.settings
        settings = {};

        // Layout Settings
        layoutSettings = {
            defaultLayout = ""
        };

        // datasources
        datasources = {};

        // SES Routes
        routes = [
            // Module Entry Point
            { pattern="/", handler="home", action="index" },
            // Convention Route
            { pattern="/:handler/:action?" }
        ];

        // Custom Declared Points
        interceptorSettings = {
            customInterceptionPoints = ""
        };

        // Custom Declared Interceptors
        interceptors = [];

        // Binder Mappings
        // binder.map("Alias").to("#moduleMapping#.model.MyService");

    }

    /**
     * Fired when the module is registered and activated.
     */
    function onLoad(){}

    /**
     * Fired when the module is unregistered and unloaded
     */
    function onUnload(){}

}
