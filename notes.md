## Spacebars partials

**Inclucisions** `{{> templateName}}` - replace with the template of the same name

**Expressions** `{{title}}` - call a property of current object or return value of a template helper

**Block helpers** tags that control the flow of the template, such as 
    `{{#each}}`...`{{/each}}` 

The `{{#each}}`
block helper not only iterates over our array, it also sets the value of `this`inside the block to the iterated object.
