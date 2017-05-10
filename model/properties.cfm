<cffunction name="$setProperties" mixin="model" hint="Overrides CFWheels internal `$setProperties` to enforce strong parameters." output="false">
	<cfset $enforceStrongParameters(argumentCollection=arguments)>
	<cfreturn core.$setProperties(argumentCollection=arguments)>
</cffunction>

<cffunction name="$enforceStrongParameters" mixin="model" hint="Call this to enforce strong parameters when mass-assigning properties." output="false">
	<cfscript>
		var loc = {};

		loc.hasWeakParams =
			application.strongParameters.required &&
			StructKeyExists(arguments, "properties") &&
			StructCount(arguments.properties) &&
			IsObject(arguments.properties) &&
			GetMetaData(arguments.properties).displayName == "WeakParams";

		// Enforce strong parameters if the controller's `params` object was passed in without properties
		// permitted.
		if (loc.hasWeakParams) {
			$throw(
				type="Wheels.StrongParameters",
				message="The mass-assigned properties were not permitted by the `params` object before passing them into the model."
			);
		}
	</cfscript>
</cffunction>
