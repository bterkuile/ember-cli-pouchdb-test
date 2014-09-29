`import DS from 'ember-data'`

Expense = DS.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')


`export default Expense`
