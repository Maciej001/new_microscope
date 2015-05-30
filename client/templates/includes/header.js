Template.header.helpers({
	activeRouteClass: function(/* route names */) {
		var args = Array.prototype.slice.call(arguments, 0);
		args.pop(); // removes hash added at the end by Spacebars

		var active = _.any(args, function(name){
			return Router.current() && Router.current().route.getName() === name
		});

		return active && 'active'
	}
});