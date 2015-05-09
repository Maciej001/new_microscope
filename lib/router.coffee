Router.configure
	layoutTemplate: 		'layout'
	loadingTemplate: 		'loading'
	notFoundTemplate: 	'notFound'
	waitOn: ->
		Meteor.subscribe 'posts'


Router.route '/', name: 'postsList'
Router.route '/posts/:_id', 
	name: 'postPage'
	data: ->
		Posts.findOne(@params._id)
Router.route '/submit', name: 'postSubmit'

# This tells Iron Router to show 'not found' page not just for invalid routes but also
# for postPage route
Router.onBeforeAction 'dataNotFound', only: 'postPage'