# This component allows two implementations of editing
# a model's attribute. Default behavior without a template
# given eg:
#   = edit-attribute model=expense attribute="name"
# Now the value in the edit field is not directly bound to
# the model's attribute. a focus out event will not save the
# value to the model.
# To directly bind the input value to the model's attribute
# use the template block
#   = edit-attribute model=expense attribute="name"
#     = input value=expense.name
# Now a focus out event will keep the value but not save
# the model.
`import Ember from 'ember'`
EditAttributeComponent = Ember.Component.extend
  editMode: false
  classNames: ['edit-attribute-container']
  classNameBindings: ['model_specific_class', 'model_generic_class', 'has_error:error']
  model_specific_class: (-> "edit-#{@model.constructor.typeKey}-#{@model.id}-attribute-container").property('model')
  model_generic_class: (-> "edit-#{@model.constructor.typeKey}-attribute-container").property('model')
  persist: true
  has_error: false
  error_explanation: Ember.computed 'has_error', ->
    return '' unless @get("model.errors.#{@attribute}.length")
    [@attribute, @get("model.errors.#{@attribute}").join(', ')].join(' ')

  value: Ember.computed (key, value, previousValue)->
    key = "model.#{@attribute}"
    if arguments.length > 1 and value isnt @get(key) #setter
      @set key, value
    @get key
  didInsertElement: ->
    @addObserver "model.#{@attribute}", (attribute)=>
      # dynamically observe the model's attribute
      # if this changes outside the component's context, it is not
      # observed by the computed property. model.@attribute is not (yet) working :)
      @set('value', @get("model.#{@attribute}")) if @get('value') isnt @get("model.#{@attribute}")
    @addObserver "model.errors.#{@attribute}.length", (attribute)=>
      @set 'has_error', !!@get("model.errors.#{@attribute}.length")
    @model.validate().then =>
      @set 'has_error', !!@get("model.errors.#{@attribute}.length")

  showEdit: (-> !@get('template') ).property('template')
  actions:
    debug: -> debugger
    toggleEdit: -> @toggleProperty('editMode')
    makeEditable: ->
      @set 'editMode', true
      setTimeout =>
        if input = @$('input:first')
          input.focus()
          tmpString = input.val()
          input.val('').val(tmpString)
      , 100
    save: ->
      return if @has_error
      @set 'editMode', false
      if @get('showEdit')
        # expect value to be set on internal field
        @set "model.#{@attribute}", @get('value')
      else
        # expect value to be set on external field
        @set "value", @get("model.#{@attribute}")
      @model.save() if @persist

      # Focus on next field if exists
      if @selectNext
        my_el = @$().get(0)
        relative_class = switch @selectNext
          when "attribute" then @get('model_specific_class')
          when "model" then @get('model_generic_class')
          else "edit-attribute-container" # Take all edit attribute fields
        my_relatives = $(".#{relative_class}")
        my_index = my_relatives.index(my_el)
        if my_index > -1 and my_index < my_relatives.length
          next_container = $(my_relatives.get(my_index + 1))
        # next_container =  @$().next(".#{@get('model_specific_class')}")
        # debugger
        if next_container
          next_container.find('.make-editable').click()
          setTimeout =>
            if input = next_container.find('input:first')
              input.focus()
              tmpString = input.val()
              input.val('').val(tmpString) # focus cursor after text, in before
          , 100
  focusOut: ->
    return if @has_error
    if @get('showEdit')
      @set "value", @get("model.#{@attribute}")
    @set 'editMode', false
  empty_attribute: (-> "<empty #{@attribute}>").property('attribute')

  # valueChanged: (->
  #   debugger
  # ).observe('edit_value')

`export default EditAttributeComponent`
