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

If you return cursor `Posts.find({'author': 'Tom'});` in a publish function, that's exactly what Meteor is using.

When Meteor sees that the `somePosts` publication has returned a cursor, it calls _publishCursor() to publish that cursor automatically. 

`_publishCursor()` does:
* checks the name of the server-side collection
* pulls all matching documents form the cursor and sends it into a client-side collection of *the same name*. It uses `added()` to do this.
* Whenever a document is added, removed, changed, sends those changes down to the client-side collection. It uses `.observe()` on the cursor and `.added()`, `.changed()` and `.removed()` to do this.

### How to publish only specific properties?
```
Meteor.publish('allPosts', function(){
        return Posts.find({}, {fields: {
                date: false // publishes all fields except of the date
            }});
    });
```

to publish Tom's posts but without dates:

```
Meteor.publish('allPosts', function(){
    return Posts.find({'author': 'Toym'}, {fields: { data: false }});
});

```

## Iron Router
**Routes** set of instructions that tell the app where to go and what to do when it encounters a URL.
**Paths** static -> `/terms_of_service`, dynamic `/posts/xyz` or include query `/search?keyword=meteor`
**Hooks** actions before, after, etc. Typical -> checking if user has rights before displaying a page
**Route Templates** If no template it will look for a template with the same name as the route by default.
**Layouts** Frames for content. Wrap current template, and remain the same even if the template itself changes.
**Controllers** contain all the common routing logic

### Mapping URLs to Templates
`{{> yield }}` helper defines a special dynamic zone that will automatically render whichever template corresponds to the current route

### /lib folder
Anything you put inside the `/lib` is loaded first before anything else in your app. Any code inside is available to both client and server environments.

`{{pathFor}}` is a spacebars helper, which returns the URL path component of any route.

Usage: 
`<a class="navbar-brand" href="{{pathFor 'postsList'}}">Microscope</a>`

### Waiting on data
You can ask Iron Router to wait on the subscription. Just move your subscriptio from main.js to router:
```
Router.configure({
    layoutTemplate: 'layout',
    waitOn: function() { return Meteor.subscribe('posts'); }
});

Router.route('/', {name: 'postsList'})
```

### Setting data context in template
```
{{#each widgets}}
    {{> widgetItem}}
{{/each}}
```

but we can explicitly use `{{#with}}` - take this object and apply the following template to it:
```
{{#with myWidget}}
    {{> widgetPage}}
{{/with}}
```

You can achieve the same result by passing the context as an argument to the template call:

`{{> widgetPage myWidget}}`

if we name the route for posts `postPage`, we acn use  `{{pathFor 'postPage'}}`Here Iron Router figures itself _id by looking for it in the data context ie. `this`. `this` here coresponds to a post, which posesses _id property.

You can pass additional argument that will create `this` context.
`{{pathFor 'postPage' someOtherPost}}`. Practical use of this pattern would be getting the link to th previous or next posts in a list.

## Session object
To set session value: `Session.set('pageTitle', 'A different title');`

to get session value: `Session.get('mySessionProperty');`

Session object is not shared betwen users, or even between browser tabs.

## Autorun
Non-reactive context -> if we change variable we won't get new `alert` whenever we change the variable.
```
hello = function() {
    alert(Session.get('message'));
}
```

code within autorun keeps running each time the reactive data soures used inside it change.

### HCR - Hot Code Reload
ON HCR Meteor saves the session to local storage in browser and loads it in again after the reload.

### Tips
* Always store user state in the Session or the URL, so that users are minimally disrupted when a hot code reload happens
* Sore any state that you want to be shareable between users within the URL itself. 

## Ading Users
`meteor add accounts-ui` or with Bootstrap:
`meteor add ian:accounts-ui-bootstrap-3`
`meteor add accounts-password`

Above commands make *special accounts templates* available to us and we can include them using `{{> loginButtons}}` helper. To controll where it shows:
`{{> loginButtons align="right"}}`.

By adding the `accounts` package, Meteor has created a special new collection, which can be accessed at Meteor.users. 

`Meteor.users.findOne();` - in browser console to check

`Meteor.user()` - returns current User

The accounts package only publishes the *current User*. 

## Reactivity
Normally Meteor updates collections automatically. There is imperative way to do this:
```
Posts.find().observe({
    added: function(post) {
        // when 'added' callback fires, add HTML element
        $('ul').append('<li id="' + post._id + '">' + post.title + '</li>');
    },
    changed: function(post) {
        // when 'changed' callback fires, modify HTML element's text
        $('ul li#' + post._id).text(post.title);
    },
    removed: function(post) {
        // when 'removed' callback fires, remove HTML element
        $('ul li#' + post._id).remove();
    }
});
```

It's usefull when dealing with third-party widgets (p104).

### Computations
Reactivity is limited to specific areas of code, and we call these areas **computations**. Computations are blocks of code that run every time one of the reactive data sources it depands on changes. 

Every reacitve data source tracks all the computations that are using it so that it can let them know when its own value changes. To do so, it calls the `invalidate()` function on the computation.

#### Setting up computations
Wrap `Tracker` code inside `Meteor.startup()` to ensure that it only runs once Meteor has finished loading the `Posts` collection.

```
Meteor.startup(function(){
    Tracker.autorun(function(){
        console.log("There are " + Posts.find().count() + " posts");
    })
});
```

## Data security
By default data security is turned off.
`meteor remove insecure` - to remove insecurity

Without insecure package client-side inserts into the posts collection are no longer allowed.

So we need eirther to tell rules for a client side, or else do our post insertions on the server-side

### Client side insertions
```
Posts = new Mongo.Collection('posts');

Posts.allow({
    insert: function(userId, doc) {
        // only allow posting if you are logged in
        return !! userId;
    }
});
```

### Securing access to the New Post form

Implementation at router level, by defining a *route hook* 

**Hook** intercepts the routing process and potentially changes the action that the router takes.

Add to `Router.onBeforeAction`

Routing hooks are *reactive*. This means we don't need to think about setting up callbacks when the user logs in: when the log-in state of the user changes, the Router's page template instantly changes from `accessDenied` to `postSubmit`.

To avoid blinking of strange templates use `Meteor.loggingIn()` for loading `loadingTemplate` first (p116).

**Hiding link** 
```
{{#if currentUser}}
    <li href="{{pathFor 'postSubmit'}}"><a>Submit Post</a><li>
{{/if}}
```

`currentUser` helper is provided by the accounts package and is Spacebars equivalent of `Meteor.user()`. And it's *reactive*.







































































































