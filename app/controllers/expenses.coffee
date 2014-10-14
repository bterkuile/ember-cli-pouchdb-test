`import Ember from 'ember'`

ExpensesController = Ember.ArrayController.extend
  new_expense_name: ''
  actions:
    debug: (expense)->
      debugger
      false
    clearNewExpense: -> @set 'new_expense_name', ''
    addNewExpense: ->
      return alert("Name must be present") unless @get('new_expense_name')
      record = @store.createRecord 'expense', name: @get('new_expense_name')
      record.save()
      @set 'new_expense_name', ''
    removeExpense: (expense)->
      if confirm("Are you sure yout want to delete expense #{expense.get('name')}?")
        expense.deleteRecord()
        expense.save()
    undoExpenseChanges: (expense)-> expense.rollback()
    editExpense: (expense) -> expense.set 'edit', true
    saveExpense: (expense)->
      expense.save() if expense.get('isDirty')
      expense.set 'edit', false

`export default ExpensesController`
