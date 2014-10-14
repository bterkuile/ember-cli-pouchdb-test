`import Ember from 'ember'`
`import DS from 'ember-data'`

Expense = DS.Model.extend Ember.Validations.Mixin,
  name: DS.attr('string')
  description: DS.attr('string')
  validations:
    name:
      presence: true


`export default Expense`
