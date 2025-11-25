This repo uses a custom code style. 

# Lua
* Lines do not end with a semicolon
* Use 1 Tab per indentation level
* Opening Brackets do not get their own line
* Each closing bracket should have its own line
* A closing parenthesis immediately after a closing bracket should be on the same line as the bracket
* When possible, make lines shorter than 80 characters
* Separate functions and methods with 1 newline
* Use unix style (LF) line endings
* When breaking up large boolean operations, break up long lines by adding a new line *before* the boolean operator
* indent multiline boolean operations with tabs until they (mostly) match the line above
* When creating a class, define the table and add methods using the : operator
* Any new classes must include a <name>.h.lua file that defines the types created

# Moonscript
* Use 1 Tab per indentation level
* strings use single quotes
* require statements use parentheses
* regular function calls do not use parentheses unless that call's return value is used as an argument to another function
* ensure lines are shorter than 80 characters where possible
## Tests
* `context` blocks should be separated by a blank line