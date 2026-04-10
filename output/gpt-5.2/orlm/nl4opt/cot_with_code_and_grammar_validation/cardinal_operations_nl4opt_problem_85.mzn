int: n_oils = 3;
set of int: OILS = 1..n_oils;

int: n_compounds = 2;
set of int: COMPOUNDS = 1..n_compounds;

array[OILS] of int: revenue = [550, 750, 950];

array[COMPOUNDS, OILS] of int: req =
  array2d(COMPOUNDS, OILS,
    [ 3, 6, 9,
      3, 2, 3
    ]);

array[COMPOUNDS] of int: avail = [250, 150];

array[OILS] of var 0.0..1.0e6: x;
var 0.0..1.0e12: total_revenue;

constraint forall(c in COMPOUNDS)(
  sum(o in OILS)(int2float(req[c,o]) * x[o]) <= int2float(avail[c])
);

constraint total_revenue =
  sum(o in OILS)(int2float(revenue[o]) * x[o]);

solve maximize total_revenue;

output [
  "x(light) = ", show(x[1]), "\n",
  "x(non_sticky) = ", show(x[2]), "\n",
  "x(heavy) = ", show(x[3]), "\n",
  "total_revenue = ", show(total_revenue), "\n"
];