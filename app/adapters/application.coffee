`import DS from 'ember-data'`

db = new PouchDB(EmberENV.APP.pouchdb.local_database_name)
errorFunc = (err)->
  console.log("CouchDB sync error")
  @cancel()
  if EmberENV.APP.pouchdb.retry_timeout
    setTimeout ->
      console.log("Trying to sync again")
      db
        .sync EmberENV.APP.pouchdb.remote_database, live: true
        .on 'error', errorFunc
    , EmberENV.APP.pouchdb.retry_timeout
if EmberENV.APP.pouchdb.remote_database
  db
    .sync EmberENV.APP.pouchdb.remote_database, live: true
    .on 'error', errorFunc
    .on 'change', (change)->
      if change.direction is "pull" and change.change.docs_read
        AtoolMobile.__container__.lookup('route:application').refresh()
# ApplicationAdapter = DS.RESTAdapter.extend()
ApplicationAdapter = EmberPouch.Adapter.extend
  db: db

`export default ApplicationAdapter`
