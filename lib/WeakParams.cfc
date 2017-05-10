<cfcomponent displayname="WeakParams" output="false">
	<cffunction name="init" output="false">
		<cfargument name="params" type="struct" hint="Parameters to load in.">
		<cfscript>
			loc.keys = ListToArray(StructKeyList(arguments.params));
			loc.end = ArrayLen(loc.keys);

			for (loc.i = 1; loc.i <= loc.end; loc.i++) {
				loc.key = loc.keys[loc.i];
				this[loc.key] = arguments.params[loc.key];
			}
		</cfscript>
		<cfreturn this>
	</cffunction>
</cfcomponent>
