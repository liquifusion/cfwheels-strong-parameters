<cffunction name="strongParams" mixin="controller" hint="Initializes a before filter that converts the params struct into strong parameters object." output="false">
	<cfset filters(through="$strongParams")>	
</cffunction>

<cffunction name="$strongParams" mixin="controller" hint="Converts params struct into strong parameters object." output="false">
	<cfset variables.params = $createObjectFromRoot(
		path="plugins/strongparameters/lib",
		fileName="Params",
		method="init",
		params=variables.params
	)>
</cffunction>
