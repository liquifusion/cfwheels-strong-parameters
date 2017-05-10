<cfcomponent output="false">
	<cffunction name="init" hint="Constructor. Sets `params` struct as public properties on this object." output="false">
		<cfargument name="params" type="struct" required="true" hint="Params to be added as properties.">
		<cfscript>
			var loc = {};

			loc.keys = ListToArray(StructKeyList(arguments.params));
			loc.end = ArrayLen(loc.keys);

			for (loc.i = 1; loc.i <= loc.end; loc.i++) {
				loc.key = loc.keys[loc.i];
				loc.param = arguments.params[loc.key];

				if (IsStruct(loc.param)) {
					this[loc.key] = $createObjectFromRoot(
						path="plugins/strongparameters/lib",
						fileName="WeakParams",
						method="init",
						params=loc.param
					);
				} else {
					this[loc.key] = arguments.params[loc.key];
				}
			}
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="require" hint="Checks that a required property key is present in the `params` object. If not, throws a `Wheels.ParamNotFound` error." output="false">
		<cfargument name="key" type="string" required="true" hint="Key to check.">
		<cfscript>
			if (StructKeyExists(this, arguments.key)) {
				this.$requirePointer = arguments.key;
			} else {
				$throw(
					"Wheels.ParamNotFound",
					"The required key #local.key# could not be found in the params object."
				);
			}

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="permit" returntype="struct" hint="Returns struct filtered by `keys` passed in. Must call `require` before calling this to indicate which struct to work with." output="false">
		<cfargument name="keys" type="string" required="true" hint="List of keys to permit to be mass assigned in the model.">
		<cfscript>
			var loc = {};
			loc.rv = {};
			loc.keys = ListToArray(arguments.keys);

			for (loc.key in loc.keys) {
				if (StructKeyExists(this[this.$requirePointer], loc.key)) {
					loc.rv[loc.key] = this[this.$requirePointer][loc.key];
				}

				loc.checkBoxKey = "#loc.key#($checkbox)";

				if (StructKeyExists(this[this.$requirePointer], loc.checkBoxKey)) {
					loc.rv[loc.checkBoxKey] = this[this.$requirePointer][loc.checkBoxKey];
				}
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="permitAll" returntype="struct" hint="Returns entire params struct. Must call `require` before calling this to indicate which struct to work with." output="false">
		<cfscript>
			var loc = {};
			loc.rv = {};
			loc.keys = ListToArray(StructKeyList(this[this.$requirePointer]));

			for (loc.key in loc.keys) {
				if (StructKeyExists(this[this.$requirePointer], loc.key)) {
					loc.rv[loc.key] = this[this.$requirePointer][loc.key];
				}
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="fileName" type="string" required="true">
		<cfargument name="method" type="string" required="true">
		<cfscript>
			var rv = "";
			var loc = {};
			loc.returnVariable = "rv";
			loc.method = arguments.method;
			loc.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
			loc.argumentCollection = arguments;
		</cfscript>
		<cfinclude template="/root.cfm">
		<cfreturn rv>
	</cffunction>
</cfcomponent>
