int: C = 2;
int: S = 3;
int: T = 6;

set of int: Cities = 1..C;
set of int: Specs = 1..S;
set of int: Types = 1..T;

array[Cities, Specs] of int: demand =
  array2d(Cities, Specs,
    [ 1000, 2000, 1500,
      2000, 1000, 1000 ]
  );

array[Types] of int: supply = [1500, 1500, 1500, 1500, 1500, 1500];

array[Types, Specs] of int: suitable =
  array2d(Types, Specs,
    [ 1,1,0,
      0,1,1,
      1,0,1,
      1,0,1,
      0,1,1,
      0,0,1 ]
  );

array[Types] of int: prefSpec = [1,2,1,3,3,3];
array[Types] of int: prefCity = [1,1,2,2,1,2];

int: Total = sum(t in Types)(supply[t]);
int: P2Target = 8000;
int: P3Target = 8000;

array[Types, Cities, Specs] of var 0..1500: x;

array[Cities, Specs] of var 0..Total: under;
array[Cities, Specs] of var 0..Total: over;

var 0..Total: matchSpec;
var 0..Total: shortSpec;

var 0..Total: matchCity;
var 0..Total: shortCity;

constraint
  forall(t in Types, c in Cities, s in Specs) (
    (suitable[t,s] = 0) -> (x[t,c,s] = 0)
  );

constraint
  forall(t in Types) (
    sum(c in Cities, s in Specs)(x[t,c,s]) <= supply[t]
  );

constraint
  forall(c in Cities, s in Specs) (
    sum(t in Types)(x[t,c,s]) + under[c,s] - over[c,s] = demand[c,s]
  );

constraint
  matchSpec = sum(t in Types, c in Cities)( x[t,c,prefSpec[t]] );

constraint
  matchCity = sum(t in Types, s in Specs)( x[t,prefCity[t],s] );

constraint
  matchSpec + shortSpec >= P2Target;

constraint
  matchCity + shortCity >= P3Target;

solve minimize
  100000000 * sum(c in Cities, s in Specs)(under[c,s])
  + 10000 * shortSpec
  + shortCity;

output [
  "total_under=", show(sum(c in Cities, s in Specs)(under[c,s])), "\n",
  "shortSpec=", show(shortSpec), "\n",
  "shortCity=", show(shortCity), "\n"
];