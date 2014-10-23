`import Ember from 'ember'`
`import DS from 'ember-data'`
attr = DS.attr
Expense = DS.Model.extend Ember.Validations.Mixin,
  name: attr('string')
  amount: attr('number')
  description: attr('string')
  invoice_date: attr('date', defaultValue: new Date())
  payment_date: attr('date', defaultValue: new Date())
  billable: attr('boolean', defaultValue: true)
  validations:
    name:
      length:
        minimum: 3

`export default Expense`
