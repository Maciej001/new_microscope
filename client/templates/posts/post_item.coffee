Template.postItem.helpers
	ownPost: ->
		console.log "this user id:", this.userId
		this.userId is Meteor.userId()

	domain: ->
		# when iterating each post is assigned to this
		a = document.createElement 'a'
		a.href = @url
		a.hostname