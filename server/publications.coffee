Meteor.publish 'posts', (options) ->
	check(options, { sort: Object, limit: Number })
	Posts.find {}, options # {} because we publish all posts

Meteor.publish 'comments', (postId) ->
	check postId, String
	Comments.find
		postId: postId

Meteor.publish 'notifications', ->
	Notifications.find
		userId: @.userId
		read: false
