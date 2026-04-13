include "alldifferent.mzn";

int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

array[1..m] of var 1..n: loop;
array[1..m] of var float: rate;
array[1..m] of var float: amt;

var float: final_amount;
var float: profit;

constraint m >= 2;
constraint start >= 0.0;

constraint all_different(loop);

constraint
  forall(i in 1..m) (
    rate[i] =
      currencies[
        loop[i],
        loop[ if i < m then i + 1 else 1 endif ]
      ]
  );

constraint amt[1] = start * rate[1];
constraint forall(i in 2..m) (amt[i] = amt[i-1] * rate[i]);

constraint final_amount = amt[m];
constraint profit = final_amount - start;

solve maximize profit;