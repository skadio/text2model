include "globals.mzn";

% ===== Input data (from .dzn) =====
int: n;                                 % number of currencies
int: m;                                 % length of arbitrage loop (number of exchanges)
array[1..n, 1..n] of float: currencies; % exchange rates: amount_in_j = amount_in_i * currencies[i,j]
array[1..n] of string: currencies_s;    % currency names
float: start;                           % initial amount in starting currency

% ===== Decision variables =====
% loop[1] is the start currency, loop[m+1] returns to start currency (to close the loop)
array[1..m+1] of var 1..n: loop;

% Amount after each exchange step (a[1] = start, a[k+1] = a[k] * rate(loop[k], loop[k+1]))
array[1..m+1] of var float: a;

% Objective: maximize profit = final_amount - start
var float: profit;

% ===== Constraints =====
constraint a[1] = start;

% close the loop
constraint loop[m+1] = loop[1];

% exchange propagation
constraint forall(k in 1..m) (
  a[k+1] = a[k] * currencies[loop[k], loop[k+1]]
);

constraint profit = a[m+1] - start;

% (Optional symmetry breaking) fix the start currency to 1 to avoid equivalent rotations
constraint loop[1] = 1;

% Require an actual arbitrage (strictly positive profit)
constraint profit > 0.0;

% ===== Solve =====
solve maximize profit;

% ===== Output =====
output
[
  "Start currency: ", currencies_s[fix(loop[1])], "\n",
  "Loop: ",
  concat([ currencies_s[fix(loop[k])] ++ if k < m+1 then " -> " else "" endif | k in 1..m+1 ]),
  "\n",
  "Final amount: ", show(a[m+1]), "\n",
  "Profit: ", show(profit), "\n"
];