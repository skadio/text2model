int: n = 4;
set of int: P = 1..n;

array[P] of int: price = [500, 1500, 300, 1200];

array[P, P] of float: a =
[| 0.0,  0.8,  0.01, 0.2
 | 0.02, 0.0,  0.01, 0.03
 | 0.0,  0.15, 0.0,  0.05
 | 0.01, 0.11, 0.05, 0.0
|];

array[P] of int: imp_goods = [250, 300, 50, 300];

array[P] of int: labor_pm = [6, 12, 6, 24];

int: labor_avail_pm = 830000;

int: cap_engines = 650000;
int: cap_plastic = 60000;

int: U = labor_avail_pm div 6;

array[P] of var 0..U: x;

var float: GDP;

constraint sum(j in P)( labor_pm[j] * x[j] ) <= labor_avail_pm;

constraint x[2] <= cap_engines;

constraint x[4] <= cap_plastic;

constraint
  GDP =
    sum(j in P)( int2float(price[j]) * int2float(x[j]) )
    - sum(j in P)( int2float(imp_goods[j]) * int2float(x[j]) )
    - sum(j in P, i in P)( int2float(price[i]) * a[i,j] * int2float(x[j]) );

solve maximize GDP;

output [
  "x = ", show(x), "\n",
  "GDP = ", show(GDP), "\n"
];