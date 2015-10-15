CSON = require("cson")
parser = {}

json2cson = (editor) ->
  grammar = editor.getGrammar().name
  wholeFile = grammar == 'JSON' || grammar == 'CSON'

  if wholeFile
    text = editor.getText()
    editor.setText(parser.toCSON(text))
  else
    text = editor.replaceSelectedText({}, (text) ->
      parser.toCSON(text)
    )

cson2json = (editor) ->
  grammar = editor.getGrammar().name
  wholeFile = grammar == 'CSON' || grammar == 'JSON'

  if wholeFile
    text = editor.getText()
    editor.setText(parser.toJSON(text))
  else
    text = editor.replaceSelectedText({}, (text) ->
      parser.toJSON(text);
    )

parser.toCSON = (text) ->
  try
    parsed = JSON.parse(text)
    CSON.stringify(parsed)
  catch error
    text;

parser.toJSON = (text) ->

  editorSettings = atom.config.get('editor')
  if editorSettings.softTabs?
    space = Array(editorSettings.tabLength + 1).join(" ")
  else
    space = "\t"

  try
    parsed = CSON.parse(text)
    JSON.stringify(parsed, null, space)
  catch error
    text;

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace',
      'Convert:JSON to CSON': ->
        editor = atom.workspace.getActiveTextEditor()
        json2cson(editor)
      'Convert:CSON to JSON': ->
        editor = atom.workspace.getActiveTextEditor()
        cson2json(editor)
