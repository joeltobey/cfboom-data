


component
    implements="coldbox.system.ioc.dsl.IDSLBuilder" 
    displayname="Class JdbcDsl"
    output="false"
{
	/**
     * Constructor as per interface
     */
    public any function init( required any injector ) {
        variables['instance'] = { "injector" = arguments.injector };
        instance['binder'] = instance.injector.getBinder();
        instance['cacheBox'] = instance.injector.getCacheBox();
        instance['log'] = instance.injector.getLogBox().getLogger( this );

        return this;
    }

    /**
     * Process an incoming DSL definition and produce an object with it.
     */
    public any function process( required definition, targetObject ) {
        var thisType = arguments.definition.dsl;
        var thisTypeLen = listLen(thisType,":");
        var objectName = "";
writeDump(arguments);
writeDump(variables);abort;
        // DSL stages
        switch(thisTypeLen){
            // DataService
            case 1 : { return instance.injector.getInstance("jdbcService@jdbc"); }
            // Domain Object
            case 2 : {
                objectName = getToken(thisType,2,":");
                if (instance.binder.mappingExists("objectName"))
                try {
                	
                } catch (any ex) {
                	if( instance.log.canDebug() ) {
                		instance.log.debug("getJdbcDsl() cannot find named object #objectName# using definition: #arguments.definition.toString()#.");
                	}
                }
					// Verify that cache exists
					if( instance.cacheBox.cacheExists( cacheName ) ){
						return instance.cacheBox.getCache( cacheName );
					}
					else if( instance.log.canDebug() ){
						instance.log.debug("getCacheBoxDSL() cannot find named cache #cacheName# using definition: #arguments.definition.toString()#. Existing cache names are #instance.cacheBox.getCacheNames().toString()#");
					}
					break;
				}
				
        }
	}
}