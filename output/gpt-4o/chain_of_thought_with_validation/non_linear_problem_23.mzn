include "globals.mzn";

int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

array[1..m] of var 1..n: path;
var float: profit;

constraint alldifferent(path);

constraint
    profit = start * product(i in 1..m)(
                 currencies[path[i], path[(i mod m) + 1]]
             ) - start;

solve maximize profit;