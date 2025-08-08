int: v;
int: k;
int: `lambda`;

int: r = (`lambda`*(v-1))/(k-1);
int: b = (v*r)/k;

constraint (`lambda`*(v-1)) mod (k-1) = 0;
constraint (v*r) mod k = 0;

array[1..b, 1..k] of var 1..v: block;
array[1..b, 1..v] of var bool: presence;

constraint forall(bi in 1..b, o in 1..v) (
    presence[bi][o] = (block[bi] contains o)
);

constraint forall(bi in 1..b) (
    all_different([block[bi][idx] | idx in 1..k])
);

constraint forall(o in 1..v) (
    sum(bi in 1..b) presence[bi][o] = r
);

constraint forall(i in 1..v-1, j in i+1..v) (
    sum(bi in 1..b) (presence[bi][i] /\ presence[bi][j]) = `lambda`
);

solve satisfy;

output [
    "Block ", show(bi), ": ", show([block[bi][idx] | idx in 1..k]), "\n" | bi in 1..b
];