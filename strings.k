/ http://beyondloom.com/blog/strings.html
\e 2
bail:{`0:,/("\nFAILED:\n"; 5:x; "\nvs\n"; 5:y; "\n"); _exit 1}

test:{[l;r] :[(5:l)_sm(5:r); `0:"." ; bail [l;r]]}
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

// 3 Sort yourself out
s:{&/(x@<x) _sm (y@<y)}
test[s["teapot";"toptea"]; 1]
test[s["apple";"elap"]; 0]
test[s["listen";"silent"]; 1]
test[s["";""]; 1]
test[s[," " ; ""]; 0]

// 4 Precious snowflakes
flakes:{groups:x[=x]; ,/groups[&1=#:'groups]}
test[flakes "somewhat heterogenous"; "mwa rgnu"]
test[flakes "abc"; "abc"]
test[flakes "aaabccddefffgg"; "be"]
test[flakes ""; ()]
test[flakes[,"a"]; ,"a"]

// 5 Musical chairs
mus:{y _in ((!#:x) !\:x)}
test[mus["foobar";"barfoo"]; 1]
test[mus["fboaro";"barfoo"]; 0]
test[mus["abcde";"deabc"]; 1]
test[mus[,"";,""]; 1]
test[mus[,""; ,"b"]; 0]
test[mus[,"a"; ,""]; 0]

// 6. Size matters
size:{[in]
s:{(#:x),y,x}  /tag with length and initial pos y
lengths:in s' !#:in
:2_'lengths@<lengths
}
test[size ("bb";,"a"); (,"a";"bb")]
test[size ("aa";,"b"); (,"b";"aa")]
test[size ("books";"apple";"peanut";"aardvark";"melon";"pie"); ("pie";"books";"apple";"melon";"peanut";"aardvark")];

// 7. Popularity contest
/popcon:{>#:'=x}
popcon:{x[**(=x)@>#:'=x]}
test[popcon "abcbbac"; "b"]
test[popcon "CCCBBBAA"; "C"]
test[popcon "CCCBBBBAA"; "B"]


`0:"\nALL TESTS PASSED\n"
_exit 0
