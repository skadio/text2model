include "alldifferent.mzn";

int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

array[1..m] of var 1..n: loop;
var float: final_amount;
var float: profit;

constraint m >= 2 /\ m <= n;
constraint all_different(loop);
constraint loop[1] = 1;

constraint
  final_amount =
    start *
    product(i in 1..(m-1))(currencies[loop[i], loop[i+1]]) *
    currencies[loop[m], loop[1]];

constraint profit = final_amount - start;

solve maximize profit;