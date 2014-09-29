`import Ember from 'ember'`
`import Resolver from 'ember/resolver'`
`import loadInitializers from 'ember/load-initializers'`
`import config from './config/environment'`
DS.Model.reopen
  save: ->
    @set 'created_at', new Date() if @get('currentState.stateName') == "root.loaded.created.uncommitted"
    @set 'updated_at', new Date() unless @get('currentState.stateName').match(/deleted/)
    @_super()
  rev: DS.attr('string')
  created_at: DS.attr('date')
  updated_at: DS.attr('date')
  attachments: DS.attr()
  database_id: (->
    # Get the real database id of the model. This is a stupid and simplyfied
    # version of the serialize(type, id) function of
    # https://github.com/nolanlawson/relational-pouch/blob/master/lib/index.js
    "#{@constructor.typeKey}_2_#{@id}"
  ).property('id')


Ember.MODEL_FACTORY_INJECTIONS = true

App = Ember.Application.extend
  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  Resolver: Resolver

loadInitializers App, config.modulePrefix

`export default App`
