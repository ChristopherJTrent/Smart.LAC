We welcome contributions to this repository, within reason. 

## When contributing, please ##
* Submit a pull request
* Post an Issue
* Update the wiki

## Please do not ##
* Berate other contributors or users
* Submit Malware
* Submit untested code

## Running tests ##
Tests are currently only supported on *nix. It is likely possible to get them running eventually on a Windows system, but that is left as an exercise for an interested reader. If you are on a windows system, use Windows Subsystem for Linux to run these tests.

### Testing Requirements ###
* System Lua (version 5.1 or greater. Ashita uses LuaJIT, which is based on 5.2)
* Luarocks
* Luacov
* Busted
* Moonscript

### Writing Tests ###  
Smart's specs are written in [Moonscript](https://moonscript.org/). This allows for a much more expressive DSL, and generally makes the entire testing process much more enjoyable. Non-Moonscript tests are supported by the library, but PRs containing non-Moonscript tests will be rejected until the tests are rewritten in the approved language.