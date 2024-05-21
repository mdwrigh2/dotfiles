syn keyword logLevelNormal I D V contained
syn keyword logLevelWarning W contained
syn keyword logLevelError E contained
syn match logDate /\d\{2}-\d\{2}/ nextgroup=logTime skipwhite
syn match logTime /\d\{2}:\d\{2}:\d\{2}\.\d\+/ nextgroup=logUid skipwhite contained
syn match logUid /\d\+/ nextgroup=logPid skipwhite contained
syn match logPid /\d\+/ nextgroup=logTid skipwhite contained
syn match logTid /\d\+/ nextgroup=logLevel skipwhite contained
syn match logLevel /[EWIDV]/ contains=logLevelNormal,logLevelWarning,logLevelError nextgroup=logTag skipwhite contained
syn match logTag /.\{-}\ze:/ nextgroup=logMsg skipwhite contained
syn match logMsg /.*/ contained

hi def link logDate Conditional
hi def link logTime Function
hi def link logUid Number
hi def link logPid Label
hi def link logTid Label
hi def link logLevelNormal Normal
hi def link logLevelWarning Debug
hi def link logLevelError Error
hi def link logTag Identifier
hi def link logMsg Normal
