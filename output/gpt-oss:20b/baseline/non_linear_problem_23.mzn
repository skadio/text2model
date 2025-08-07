include "globals.mzn";

int: n;                     % number of currencies
int: m;                     % length of the arbitrage loop
array[1..n,1..n] of float: currencies;   % exchange rates
array[1..n] of string: currencies_s;     % currency names
float: start;               % initial amount in the base currency

% We assume the base currency is the first one in the list
int: base = 1;

array[1..m] of var 1..n: seq;          % sequence of currencies in the loop
constraint all_different(seq);          % all currencies in the loop must be distinct
constraint forall(i in 1..m) (seq[i] != base);   % the base currency is not part of the loop

% Pre‑compute the logarithms of the exchange rates
array[1..n,1..n] of float: logrates = 
  [ [ log(currencies[i,j]) | j in 1..n ] | i in 1..n ];

% Compute the sum of logarithms along the loop (base -> first -> … -> last -> base)
var float: logprod = 
  logrates[base, seq[1]] 
  + sum([ logrates[seq[i], seq[i+1]] | i in 1..m-1 ])
  + logrates[seq[m], base];

% The objective is to maximise the product of the rates, i.e. maximise logprod
solve maximize logprod;

% Compute the actual product and profit for reporting
var float: product = exp(logprod);
var float: profit = start * product - start;

output [
  "Arbitrage loop: ", show([ currencies_s[seq[i]] | i in 1..m ]), "\n",
  "Product of rates: ", show(product), "\n",
  "Profit: ", show(profit), "\n"
];