int: n;
int: m;

array[1..n, 1..n] of float: currencies;   % exchange rates i -> j
array[1..n] of string: currencies_s;      % currency names
float: start;                              % initial amount in base currency

set of int: C = 1..n;
set of int: P = 1..m;

% Arbitrage loop as indices into currencies_s (names can be read from solution)
array[P] of var C: arbitrageLoop;

% Amount after each exchange step (step 1 is the starting amount)
array[1..m+1] of var float: amt;

constraint amt[1] = start;

% Apply exchanges along the loop
constraint forall(k in 1..m) (
  amt[k+1] = amt[k] * currencies[arbitrageLoop[k], arbitrageLoop[ if k < m then k+1 else 1 endif ]]
);

% Profitable loop: end with more than we started
constraint amt[m+1] > start;

var float: profit = amt[m+1] - start;

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "final_amount = ", show(amt[m+1]), "\n",
  "loop_indices = ", show(arbitrageLoop), "\n",
  "loop_currencies = [",
    concat([ currencies_s[fix(arbitrageLoop[k])] ++ (if k < m then ", " else "" endif) | k in P ]),
  "]\n"
];