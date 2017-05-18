<cfcomponent displayname="ProtectedParams" output="false">
	<cffunction name="init" output="false">
		<cfargument name="params" type="struct" hint="Parameters to load in.">
		<cfscript>
			loc.keys = ListToArray(StructKeyList(arguments.params, "|"), "|");
			loc.end = ArrayLen(loc.keys);

			for (loc.i = 1; loc.i <= loc.end; loc.i++) {
				loc.key = loc.keys[loc.i];
				loc.prop = arguments.params[loc.key];

				if (IsStruct(arguments.params[loc.key])) {
					this[loc.key] = CreateObject("component", "ProtectedParams").init(loc.prop);
				} else {
					this[loc.key] = loc.prop;
				}
			}
		</cfscript>
		<cfreturn this>
	</cffunction>
</cfcomponent>
