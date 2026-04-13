int: n_oils = 3;
set of int: OILS = 1..n_oils;

int: Light = 1;
int: NonSticky = 2;
int: Heavy = 3;

array[OILS] of int: revenue = [550, 750, 950];

int: n_compounds = 2;
set of int: COMPOUNDS = 1..n_compounds;

int: A = 1;
int: B = 2;

array[COMPOUNDS] of int: available = [250, 150];

array[COMPOUNDS, OILS] of int: req = array2d(COMPOUNDS, OILS, [
  3, 6, 9,
  3, 2, 3
]);

array[OILS] of var float: x;
var float: total_revenue;

constraint forall(o in OILS)(x[o] >= 0.0);

constraint
  forall(c in COMPOUNDS)(
    sum(o in OILS)(int2float(req[c, o]) * x[o]) <= int2float(available[c])
  );

constraint
  total_revenue = sum(o in OILS)(int2float(revenue[o]) * x[o]);

solve maximize total_revenue;

output [
  "Light=", show(x[Light]), "\n",
  "NonSticky=", show(x[NonSticky]), "\n",
  "Heavy=", show(x[Heavy]), "\n",
  "TotalRevenue=", show(total_revenue), "\n"
];