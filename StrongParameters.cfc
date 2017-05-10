<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfset this.version = "1.4.0,1.4.1,1.4.2,1.4.3,1.4.4,1.4.5">
		<cfreturn this>
	</cffunction>

	<cfinclude template="events/onapplicationstart.cfm">
	<cfinclude template="controller/strongparams.cfm">
	<cfinclude template="model/properties.cfm">
</cfcomponent>
