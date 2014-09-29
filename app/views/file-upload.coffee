`import Ember from 'ember'`

FileUploadView = Ember.TextField.extend
  type: 'file'
  change: (evt)->
    input = evt.target

     # We're using a single upload, but multiple could be
    # supported by adding `multiple` on the input element
    # and iterating over the files list here.
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e) =>
        uploadedFile = e.srcElement.result

        # Perform the action configured for this instance
        @sendAction 'action', uploadedFile, input.files[0].type
      reader.readAsBinaryString input.files[0]
      # reader.readAsDataURL input.files[0]
      # reader.readAsText input.files[0]

`export default FileUploadView`
