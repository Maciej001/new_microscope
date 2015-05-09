## Spacebars partials

**Inclucisions** `{{> templateName}}` - replace with the template of the same name

**Expressions** `{{title}}` - call a property of current object or return value of a template helper

**Block helpers** tags that control the flow of the template, such as 
    `{{#each}}`...`{{/each}}` 

The `{{#each}}`
block helper not only iterates over our array, it also sets the value of `this`inside the block to the iterated object.

`meteor shell` - gives you direct access to you app's server-side code

`meteor mongo` - gives you access to your app's database (Mongo Console)
`meteor mongo myApp` - you can access your deployed app's Mongo shell with it
`meteor reset` - to reset the database

```
> db.posts.insert({title: "A new post"});
> db.posts.find();
```

Client side database implementation is called **MiniMongo**

### Find and Fetch
`find()` - returns cursor, which is a reactive data source. When we want to log it's contents, we can use:
`fetch()` - on that cursor to transform it into an array

Within an app, Meteor iterates over cursors without having to convert them into arrays first.

`meteor remove autopublish` - each collection should be shared in its entirety to each connected client. Remove it to stop the automatic behaviour.

### Publications
In server catalogue create publications.js and add what collections you want to be published. 
`Meteor.publish('posts', function() { return Posts.find(); } );`

on client side we need need to subscribe to the publications in client/main.js
`Meteor.subscribe('posts');`

to publish eg. only not flagged posts:
```
Meteor.publish('posts', function(){
        return Posts.find({flagged: false});
    });
```

We need a way for clients to specify which subset of that data they need at any particular moment, and that’s exactly where subscriptions come in.
Any data you subsciribe to will be mirrored on the client thanks to Minimongo.

Let's say we want just to subscribe to **all** Bob Smith's posts:

on the server side:
```
Meteor.publish('posts', function(){
        return Posts.find({flagged: false, author: author})
    });
```

on client side:
```
Meteor.subscribe('posts', 'bob-smith');
```

it loads all Bob's posts, but we want to display only posts form "Javascript" category. So on client side:
```
Template.posts.helpers({
        posts: function() {
            return Posts.find({autor: 'bob-smith', category: 'Javascript'});
        }
    });
```















































