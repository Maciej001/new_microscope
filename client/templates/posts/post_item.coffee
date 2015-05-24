Template.postItem.helpers
	ownPost: ->
		this.userId is Meteor.userId()

	domain: ->
		# when iterating each post is assigned to this
		a = document.createElement 'a'
		a.href = @url
		a.hostname

	upvotedClass: ->
		userId = Meteor.userId()
		if userId && !_.include(@upvoters, userId)
			'btn-primary upvotable'
		else
			'disabled'

Template.postItem.events
	'click .upvotable': (e) ->
		e.preventDefault()
		Meteor.call 'upvote', this._id



