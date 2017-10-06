CSON = require("cson")
parser = {}

space = (scope) ->
  if atom.config.get('editor.softTabs', scope: [scope])?
    Array(atom.config.get('editor.tabLength', scope: [scope]) + 1).join(" ")
  else
    "\t"

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
    CSON.stringify(parsed, null, space('source.coffee'))
  catch error
    text;

parser.toJSON = (text) ->
  try
    parsed = CSON.parse(text)
    JSON.stringify(parsed, null, space('source.json'))
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
