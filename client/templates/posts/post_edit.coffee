Template.postEdit.onCreated ->
	Session.set 'postEditErrors', {}

Template.postEdit.helpers
	errorMessage: (field) ->
		Session.get('postEditErrors')[field]

	errorClass: (field) ->
		return !!Session.get('postEditErrors')[field] ? 'has-error' : ''

Template.postEdit.events
	'submit form': (e) -> 
		e.preventDefault()

		currentPostId = @._id

		postProperties = 
			url: 		$(e.target).find('[name=url]').val()
			title: 	$(e.target).find('[name=title]').val()

		errors = validatePost postProperties
		if errors.title or errors.url
			console.log "there are errors", errors
			session_errors = Session.set('postEditErrors', errors)
			return session_errors

		Posts.update currentPostId, $set: postProperties, (error) ->
			if error
				throwError error.reason
			else 
				Router.go 'postPage', _id: currentPostId

	'click .delete': (e) ->
		e.preventDefault()

		if confirm "Delete this post?"
			currentPostId = @._id;
			Posts.remove currentPostId
			Router.go 'home'
