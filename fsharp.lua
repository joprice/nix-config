local s =
"./server/SerializationTests.fs(29,3): (29,4) error FSHARP: A type parameter is missing a constraint 'when 'a: equality' (code 1)roject and references (80 source files) parsed in 119ms"
local inspect = require('inspect')

for file, startLine in s:gmatch([[(.-)%((%d).+$]]) do
  print(inspect({ file, startLine }))
end
