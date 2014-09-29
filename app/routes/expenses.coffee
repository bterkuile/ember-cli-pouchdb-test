`import Ember from 'ember'`

ExpensesRoute = Ember.Route.extend
  model: -> @store.find 'expense'

`export default ExpensesRoute`
