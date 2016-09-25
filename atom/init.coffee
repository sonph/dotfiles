# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"
wrap = (pair, event) ->
  editor = atom.workspace.getActiveTextEditor()
  checkpoint = editor.createCheckpoint()
  editor.cutSelectedText()
  editor.insertText(pair[0])
  editor.pasteText()
  editor.insertText(pair[1])
  editor.groupChangesSinceCheckpoint(checkpoint)

atom.commands.add 'atom-text-editor',
  'user-vim-visual:wrap-square-brackets': (event) ->
    wrap('[]', event)

atom.commands.add 'atom-text-editor',
  'user-vim-visual:wrap-parentheses': (event) ->
    wrap('()', event)

atom.commands.add 'atom-text-editor',
  'user-vim-visual:wrap-single-quotes': (event) ->
    wrap('\'\'', event)

atom.commands.add 'atom-text-editor',
  'user-vim-visual:wrap-double-quotes': (event) ->
    wrap('""', event)
