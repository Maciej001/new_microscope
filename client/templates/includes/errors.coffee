Template.errors.helpers
	errors: ->
		Errors.find()


# onRendered callback triggers once the template has been rendered. 
# this refers to the current template instance - here error is attached
Template.error.onRendered ->
	error = @.data
	Meteor.delay = (ms, func) -> setTimeout func, ms
	Meteor.delay 3000, ->
		Errors.remove error._id
