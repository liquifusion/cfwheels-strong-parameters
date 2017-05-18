<cffunction name="$setProperties" mixin="model" hint="Overrides CFWheels internal `$setProperties` to enforce strong parameters." output="false">
	<cfscript>
		if (application.strongParameters.required && StructKeyExists(arguments, "properties") && StructCount(arguments.properties)) {
			$enforceStrongParameters(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn core.$setProperties(argumentCollection=arguments)>
</cffunction>

<cffunction name="$enforceStrongParameters" mixin="model" hint="Call this to enforce strong parameters when mass-assigning properties." output="false">
	<cfscript>
		var loc = {};

		// Base struct
		$throwIfProtectedParams(properties=arguments.properties);

		// Nested structs
		loc.keys = ListToArray(StructKeyList(arguments.properties, "|"), "|");
		loc.end = ArrayLen(loc.keys);

		for (loc.i = 1; loc.i <= loc.end; loc.i++) {
			loc.key = loc.keys[loc.i];

			if (IsStruct(arguments.properties[loc.key])) {
				$enforceStrongParameters(properties=arguments.properties[loc.key]);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$throwIfProtectedParams" mixin="model" hint="" output="false">
	<cfscript>
		var loc = {};

		loc.hasProtectedParams =
			IsObject(arguments.properties) &&
			GetMetaData(arguments.properties).displayName == "ProtectedParams";

		// Enforce strong parameters if the controller's `params` object was passed in without properties
		// permitted.
		if (loc.hasProtectedParams) {
			$throw(
				type="Wheels.ProtectedParameters",
				message="The mass-assigned properties were not permitted by the `params` object before passing them into the model."
			);
		}
	</cfscript>
</cffunction>
