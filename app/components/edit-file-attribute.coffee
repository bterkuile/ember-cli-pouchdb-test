`import Ember from 'ember'`

EditFileAttributeComponent = Ember.Component.extend
  editMode: false
  makeEditable: -> @set 'editMode', true
  notEditable: -> @set 'editMode', false
  doFileStuff: (file, file_type)->
    db = @container.lookup('adapter:application').db
    db.putAttachment @get('model.database_id'), @attribute, @get('model.rev'), btoa(file), file_type, (err, res)=>
      @set 'file_base64_src', null
      @model.reload()
      # @model.set 'rev', res.rev if res
      # h = {}
      # h[@attribute] = {content_type: file_type}
      # @model.set 'attachments', Ember.Object.create(h)
  # focusOut: -> @set 'editMode', false
  filePresent: (->
    @get("model.attachments.#{@attribute}")
  ).property('model.attachments')

  attachment_size: null
  file_human_size: Ember.computed 'attachment_size', ->
    # pouchdb does not yet support attachment length, so
    # this implementation is hypothetical
    humanize = (size) -> " #{size/1000} kB"
    if size = @get('attachment_size')
      humanize size
    else
      ""

  didInsertElement: (el)->
    length_key = "model.attachments.#{@attribute}.length"
    @addObserver length_key, => @set 'attachment_size', @get(length_key)

  file_image_tag: Ember.computed "model.attachments", "file_base64_src", ->
    component = @
    if file = @get("model.attachments.#{@attribute}")
      if ['image/png', "image/jpeg"].indexOf(file.content_type) > -1
        if src = @get('file_base64_src')
          new Ember.Handlebars.SafeString("<img src=\"#{src}\" alt=\"\">")
        else
          db = @container.lookup('adapter:application').db
          db.getAttachment @get('model.database_id'), @attribute, (err, res)=>
            if err
              # nothing yet
            else
              reader = new FileReader()
              reader.onload = (reader_event)->

                # setTimeout (->component.set 'file_base64_src', reader_event.target.result), 3000
                component.set 'file_base64_src', reader_event.target.result
              reader.readAsDataURL(res)

          new Ember.Handlebars.SafeString("<span class=\"file-image-loading\"></span>")
      else
        new Ember.Handlebars.SafeString("<span class=\"file-no-image\"></span>")
    else
      new Ember.Handlebars.SafeString("<span class=\"file-not-present\"></span>")

`export default EditFileAttributeComponent`
