include "globals.mzn";

int: C = 2;
int: S = 3;
int: T = 6;

set of int: Cities = 1..C;
set of int: Specs  = 1..S;
set of int: Types  = 1..T;

array[Cities, Specs] of int: demand =
  array2d(Cities, Specs,
    [ 1000, 2000, 1500,
      2000, 1000, 1000
    ]);

array[Types] of int: supply = [1500,1500,1500,1500,1500,1500];

array[Types, Specs] of bool: suitable =
  array2d(Types, Specs,
    [ true,  true,  false,
      false, true,  true,
      true,  false, true,
      true,  false, true,
      false, true,  true,
      false, false, true
    ]);

array[Types] of int: prefSpec = [1,2,1,3,3,3];
array[Types] of int: prefCity = [1,1,2,2,1,2];

int: P2_target = 8000;
int: total_people = sum(t in Types)(supply[t]);

array[Types, Cities, Specs] of var 0..total_people: x;

var 0..total_people: meetPrefSpec;
var 0..total_people: meetPrefCity;

constraint forall(t in Types)(
  sum(c in Cities, s in Specs)(x[t,c,s]) = supply[t]
);

constraint forall(t in Types, c in Cities, s in Specs where not suitable[t,s])(
  x[t,c,s] = 0
);

constraint forall(c in Cities, s in Specs)(
  sum(t in Types)(x[t,c,s]) = demand[c,s]
);

constraint meetPrefSpec = sum(t in Types, c in Cities)(x[t,c,prefSpec[t]]);
constraint meetPrefCity = sum(t in Types, s in Specs)(x[t,prefCity[t],s]);

constraint meetPrefSpec >= P2_target;

solve minimize (total_people - meetPrefCity);

output [
  "People not meeting preferred city (min): ", show(total_people - meetPrefCity), "\n",
  "meetPrefSpec=", show(meetPrefSpec), " meetPrefCity=", show(meetPrefCity), "\n"
];