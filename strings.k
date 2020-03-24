/ http://beyondloom.com/blog/strings.html
\e 2
bail:{`0:,/("\nFAILED:\n"; 5:x; "\nvs\n"; 5:y; "\n"); _exit 1}
test:{[l;r] :[(5:l)_sm(5:r); `0:" ",$l ; bail [l;r]]}

/ http://beyondloom.com/blog/strings.html
/ 0 Multiplicity
mult:{+/(y=)' x}
test[mult["fhqwhgads";"h"]; 2]
test[mult["mississippi";"s"];  4]
test[mult["life";"."]; 0]

/ 1 Trapeze Part
trapeze:{&/x=|x}
test[trapeze "racecar"; 1]
test[trapeze "wasitaratisaw"; 1]
test[trapeze "palindrome"; 0]

// 2 Duplicity
dupli:{,/1_'x@=x}
test[dupli "applause";  "ap"]
test[dupli "foo"; ,"o"]
test[dupli "baz";  ""]


`0:"\nALL TESTS PASSED\n"
_exit 0
