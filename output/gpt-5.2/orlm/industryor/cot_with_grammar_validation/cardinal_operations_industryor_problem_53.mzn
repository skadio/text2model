int: P = 3;
int: E = 3;

set of int: Products = 1..P;
set of int: Equip = 1..E;

array[Equip, Products] of int: hours =
  array2d(Equip, Products,
    [ 8,  2, 10,
     10,  5,  8,
      2, 13, 10
    ]);

array[Equip] of int: capacity = [300, 400, 420];

array[Products] of float: profit = [3.0, 2.0, 2.9];

array[Products] of var float: x;
var float: total_profit;

constraint forall(e in Equip) (
  sum(p in Products)(int2float(hours[e,p]) * x[p]) <= int2float(capacity[e])
);

constraint forall(p in Products) (x[p] >= 0.0);

constraint total_profit = sum(p in Products)(profit[p] * x[p]);

solve maximize total_profit;

output [
  "x = ", show(x), "\n",
  "total_profit = ", show(total_profit), "\n"
];