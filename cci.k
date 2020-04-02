\e 2
bail:{`0:,/("\nFAILED:\n"; 5:x; "\nvs\n"; 5:y; "\n"); _exit 1}
test:{[l;r] :[(5:l)_sm(5:r); `0:"." ; bail [l;r]]}

/ 1.1 does a string have unique characters?
hasUnique:{(#?x) = #:x}
test[hasUnique "abc"; 1]
test[hasUnique "baca"; 0]
test[hasUnique ""; 1]
test[hasUnique "Aa"; 1]

/ 1.2 is s1 a permutation of s2?
isPermutation:{(x@<x) _sm (y@<y)}
test[isPermutation["";""]; 1]
test[isPermutation[""; ,"a"]; 0]
test[isPermutation["aba";"baa"]; 1]
test[isPermutation["abc";"abc"]; 1]
test[isPermutation["aaaa";"aaaa"]; 1]
test[isPermutation["aaab";"bbba"]; 0]

_exit 0