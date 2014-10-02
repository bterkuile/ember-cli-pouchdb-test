# Atool-mobile

This README outlines the details of collaborating on this Ember application.

This is a small demo application intended to have an example for an offline
application capable of syncing with a remote couchdb database, even handling
connection failures without slowing down the application use.

## Use cases for this approach

### When to use

* The amount of data per user is reasonable small
* The application must work crisp in offline situations

### When not to use

* The amount of backend data that must be available/possible
  to access per user is large
* The accessibility/authorization for specific data is a complex/highly manageable system
* When attachments explicitly need to be added to new records in stead
  of already locally persited ones. (rare usecase, but okay it there)

## Dependency hacks

Since the ecosystem hardly ever is completely perfect. Some changes to dependencies
might be required.

### relational-pouch
At the moment relational pouch does not support attachments. To add this
support edit: 
<tt>bower_components/relational-pouch/dist/pouchdb.relational-pouch.js</tt>
Add <tt>obj.attachments = Ember.Object.create(pouchDoc._attachments);</tt> to transformOutput.

```javascript
  function transformOutput(typeInfo, pouchDoc) {
    var obj = pouchDoc.data;
    obj.id = deserialize(pouchDoc._id);
    obj.rev = pouchDoc._rev;
    obj.attachments = Ember.Object.create(pouchDoc._attachments);
    return obj;
  }
```
### pouchdb

This dependency just works. There is however already a preliminary implementation for attachment
size support, awaiting https://github.com/pouchdb/pouchdb/issues/2708 to be implemented.


## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM) and [Bower](http://bower.io/)

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at http://localhost:4200.

### Code Generators

Make use of the many generators for code, try `ember help generate` for more details

### Running Tests

* `ember test`
* `ember test --server`

### Building

* `ember build` (development)
* `ember build --environment production` (production)

### Deploying

Specify what it takes to deploy your app.

## Further Reading / Useful Links

* ember: http://emberjs.com/
* ember-cli: http://www.ember-cli.com/
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
