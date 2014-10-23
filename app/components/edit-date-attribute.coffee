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
EditDateAttributeComponent = Ember.Component.extend
  editMode: false
  classNames: ['edit-attribute-container']
  classNameBindings: ['model_specific_class', 'model_generic_class', 'has_error:error']
  model_specific_class: (-> "edit-#{@model.constructor.typeKey}-#{@model.id}-attribute-container").property('model')
  model_generic_class: (-> "edit-#{@model.constructor.typeKey}-attribute-container").property('model')
  persist: true
  has_error: false
  emptyText: 'not_set'
  error_explanation: Ember.computed 'has_error', ->
    return '' unless @get("model.errors.#{@attribute}.length")
    [@attribute, @get("model.errors.#{@attribute}").join(', ')].join(' ')

  value: Ember.computed (key, value, previousValue)->
    key = "model.#{@attribute}"
    if arguments.length > 1 # and value isnt @get(key) #setter
      if value
        if typeof value is 'string' #coming from field, if Date object model attribute is already set
          if value.length is 10
            date_value = new Date(value)
            @set 'has_error', false
            @set key, date_value
          else
            @set 'has_error', true
      else
        @set key, null # empty date
        @set 'has_error', false
      get_value = value
    get_value ||= @get key

    if get_value
      get_value = get_value.toISOString() if typeof get_value is 'object'
      get_value = get_value.substr(0,10) if typeof get_value  is 'string'
    get_value

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
    return false if @has_error
    @set 'editMode', false
  empty_attribute: (-> if @emptyText is "not_set" then "<no #{@attribute}>" else @emptyText).property('attribute')

`export default EditDateAttributeComponent`
