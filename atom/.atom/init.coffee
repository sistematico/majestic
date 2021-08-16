atom.commands.add 'atom-workpace',
  'me:personalize-whitespace', ->
    view = atom.views.getView(atom.workspace.getActiveTextEditor())
    atom.commands
      .dispatch(view, 'whitespace:convert-all-tabs-to-spaces')
      .then () -> atom.commands
        .dispatch(view, 'whitespace:remove-trailing-whitespace')
      .then () -> atom.commands
        .dispatch(view, 'line-ending-selector:convert-to-LF')

atom.commands.add 'atom-workspace',
  'custom:insert-timestamp': ->
    now = new Date()
    atom.workspace.getActiveTextEditor().insertText(now.toISOString())
