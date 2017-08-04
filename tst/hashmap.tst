gap> START_TEST("hashmap.tst");

##########################################
#
# Test hashmap with integer keys
#
gap> hashmap := DS_Hash_Create( IdFunc, \=, 5 );;

# add stuff
gap> for i in [1..1000] do
>     DS_Hash_SetValue(hashmap, i, i^2);
> od;

# query it back
gap> ForAll([1..1000], i -> DS_Hash_Value(hashmap, i) = i^2);
true

# check for presence of objects known to be contained in the hashmap
gap> ForAll([1..1000], i -> DS_Hash_Contains(hashmap, i));
true

# check for presence of objects known to be NOT contained in the hashmap
gap> DS_Hash_Contains(hashmap, 0);
false
gap> ForAny([1001..2000], i -> DS_Hash_Contains(hashmap, i));
false

# delete something
gap> DS_Hash_Delete(hashmap, 100);
10000
gap> DS_Hash_Delete(hashmap, 567);
321489

# verify
gap> Filtered([1..1000], i -> not DS_Hash_Contains(hashmap, i));
[ 100, 567 ]

#
gap> IsBound(hashmap[100]);
false
gap> IsBound(hashmap[200]);
true
gap> IsBound(hashmap[567]);
false

#
gap> hashmap[100] := 42;
42

#
gap> IsBound(hashmap[100]);
true
gap> IsBound(hashmap[200]);
true
gap> IsBound(hashmap[567]);
false

# verify
gap> Filtered([1..1000], i -> not DS_Hash_Contains(hashmap, i));
[ 567 ]

#
gap> hashmap[567];
fail
gap> DS_Hash_AccumulateValue(hashmap, 567, 1, SUM);
false
gap> hashmap[567];
1
gap> DS_Hash_AccumulateValue(hashmap, 567, 1, SUM);
true
gap> hashmap[567];
2

# verify
gap> Filtered([1..1000], i -> not DS_Hash_Contains(hashmap, i));
[  ]

##########################################
#
# Test hashmap with string keys
#
#
gap> hashfun := function(str)
>     Assert(0, IsStringRep(str));
>     return HashKeyBag(str, 0, 0, -1);
> end;;
gap> hashmap := DS_Hash_Create( hashfun, \=, 20 );;
gap> DS_Hash_Capacity(hashmap);
32

# add stuff
gap> keys := List([1..1000], i -> String(HashKeyBag(2^100+i, 0,0,-1)));;
gap> for i in [1..Length(keys)] do
>     DS_Hash_SetValue(hashmap, keys[i], i^2);
> od;

# query it back
gap> ForAll([1..Length(keys)], i -> DS_Hash_Value(hashmap, keys[i]) = i^2);
true

# check for presence of objects known to be contained in the hashmap
gap> ForAll(keys, key -> DS_Hash_Contains(hashmap, key));
true

# check for presence of objects known to be NOT contained in the hashmap
gap> DS_Hash_Contains(hashmap, "test");
false
gap> ForAny([1001..2000], i -> DS_Hash_Contains(hashmap, String(i)));
false

# delete something
gap> DS_Hash_Delete(hashmap, keys[100]);
10000
gap> DS_Hash_Delete(hashmap, keys[567]);
321489

# verify
gap> keys{[100,567]} = Filtered(keys, key -> not DS_Hash_Contains(hashmap, key));
true

#
gap> STOP_TEST( "hashmap.tst", 1);