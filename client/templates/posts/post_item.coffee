Template.postItem.helpers
	ownPost: ->
		this.userId is Meteor.userId()

	domain: ->
		# when iterating each post is assigned to this
		a = document.createElement 'a'
		a.href = @url
		a.hostname

	commentsCount: ->
		comments = Comments.find
			postId: @._id
			
		comments.count()

