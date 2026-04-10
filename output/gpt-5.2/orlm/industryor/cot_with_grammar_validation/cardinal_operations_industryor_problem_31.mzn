int: W = 4;
int: C = 3;

set of int: WORKSHOPS = 1..W;
set of int: COMPONENTS = 1..C;

array[WORKSHOPS] of int: capacity = [100, 150, 80, 200];

array[WORKSHOPS, COMPONENTS] of int: rate =
  array2d(WORKSHOPS, COMPONENTS,
    [
      10, 15,  5,
      15, 10,  5,
      20,  5, 10,
      10, 15, 20
    ]
  );

array[WORKSHOPS, COMPONENTS] of var float: hours;
var float: products;

constraint forall(w in WORKSHOPS) (
  sum(c in COMPONENTS)(hours[w,c]) <= int2float(capacity[w])
);

constraint forall(c in COMPONENTS) (
  sum(w in WORKSHOPS)(int2float(rate[w,c]) * hours[w,c]) >= products
);

constraint products >= 0.0;
constraint forall(w in WORKSHOPS, c in COMPONENTS) (hours[w,c] >= 0.0);

solve maximize products;

output [
  "products = ", show(products), "\n",
  "hours =\n",
  show(hours), "\n"
];