local s =
"./server/SerializationTests.fs(29,3): (29,4) error FSHARP: A type parameter is missing a constraint 'when 'a: equality' (code 1)"
local inspect = require('inspect')

-- parses https://github.com/fable-compiler/Fable/blob/de7d3fa111207d67514ed59ea925e4cd30c7008a/src/Fable.Cli/Main.fs#L83
-- similar to the regex here https://github.com/ionide/ionide-vscode-fsharp/blob/4586785a8ecbaf2c9811b373e0cfc22bffb089e8/release/package.json#L1682-L1707
for filename, line, col, end_line, end_column, severity, message in s:gmatch([[(.-)%((%d+),(%d+)%): %((%d+),(%d+)%) (.+) FSHARP: (.+)$]]) do
  print(inspect({
    filename = filename,
    row = line,
    col = col,
    end_row = end_line,
    end_col = end_column,
    message = message,
    severity = severity
  }))
end
