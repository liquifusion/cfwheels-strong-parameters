# CFWheels Strong Parameters

Protect against mass assignment vulnerabilities with a smarter `params` object in the controller.

## Setup

Install this plugin by grabbing the zip file from the latest release in the [Releases tab][1] on
GitHub, placing it in the plugins folder of your CFWheels application, and reloading your app.

Next, add a call to the `strongParams` controller intializer in your base
`controllers/Controller.cfc`:

```javascript
function init() {
	strongParams();
}
```

Your model will now expect all mass assignment of properties from form posts and `GET` parameters to
be cleared by the `require` and `permit` methods.

## Usage

Any model method that accepts a struct of properties (or a set of named arguments) to set on the
model will not work if you pass that struct directly from `params`:

```javascript
// Throws an exception if `params.user` came from the URL or a form post.
user = model("user").new(params.user);

// Works fine.
user = model("user").new(name: "Andrew", isAdmin: true);

// Also works fine.
userParams = { name="Andrew", isAdmin=true };
user = model("user").new(userParams);
```

The model will accept a struct of parameters from the `params` object if you call its `require` and
`permit` methods:

```javascript
// Works fine! BUT this will only accept `name` and not `isAdmin` from a form post.
user = model("user").new(params.require("user").permit("name"));
```

A common pattern is to split the `require`/`permit` logic into a separate private method in your
controller:

```javascript
function create() {
	user = model("user").new(userParams());

	if (user.save()) {
		redirectTo(route: "user", key: user.key());
	} else {
		renderPage(action: "new");
	}
}

private struct function userParams() {
	return params.require("user").permit("name");
}
```

You then have a clean way to expand upon mass assignment logic based on permissions or whatever
logic you need:

```javascript
private struct function userParams() {
	local.p = ["name"];

	// User admins can set the `isAdmin` property from the form, but normal users cannot.
	if (hasPermission("user-admin")) {
		ArrayAppend(local.p, "isAdmin");
	}

	return params.require("user").permit(ArrayToList(local.p));
}
```

If you (for whatever reason) don't care about the parameters passed in via mass assignment, you can
use the `permitAll` method on the `params` object:

```javascript
private struct function userParams() {
	return params.require("user").permitAll();
}
```

## License

The MIT License (MIT)

Copyright (c) 2017 Liquifusion Studios

[1]: https://github.com/liquifusion/cfwheels-strong-parameters/releases
