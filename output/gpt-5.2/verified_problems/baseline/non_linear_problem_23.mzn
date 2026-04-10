int: n;
int: m;
array[1..n, 1..n] of float: currencies;     % exchange rate from i to j
array[1..n] of string: currencies_s;         % currency names (unused by solver)
float: start;                                % initial amount

set of int: C = 1..n;
set of int: P = 1..m;

array[P] of var C: path;                     % sequence of currencies in loop
constraint path[1] == path[m];               % closed loop

% Optional: prevent trivial self-loop (can be removed if allowed)
constraint exists(p in 1..m-1)(path[p] != path[p+1]);

% Break rotational symmetry: fix the starting currency to 1
constraint path[1] == 1;

% Product of exchange rates along the path
var float: rate_product =
  product(p in 1..m-1)( currencies[path[p], path[p+1]] );

% Final amount and profit
var float: final_amount = start * rate_product;
var float: profit = final_amount - start;

% Require an arbitrage (strictly profitable). If you want best loop even if not profitable, remove this.
constraint profit > 0.0;

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "final_amount = ", show(final_amount), "\n",
  "rate_product = ", show(rate_product), "\n",
  "path_idx = ", show(path), "\n",
  "path_names = [",
  concat([ if p > 1 then ", " else "" endif ++ currencies_s[fix(path[p])] | p in P ]),
  "]\n"
];