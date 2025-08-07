include "globals.mzn";

/* ---------- Data ---------- */
int: n;                           % total number of currencies
int: m;                           % number of currencies in the loop
array[1..n, 1..n] of float: currencies;    % exchange rate from i to j
array[1..n] of string: currencies_s;       % currency names (not used in the model)
float: start;                     % initial amount in the base currency

/* ---------- Variables ---------- */
array[1..m] of var 1..n: loop;           % indices of currencies in the arbitrage loop
constraint all_different(loop);          % every currency appears at most once

/* Edge rates: rate of exchange from loop[i] to loop[i+1] (with wrap‑around) */
array[1..m] of var float: edge_rate =
    [currencies[loop[i], loop[(i mod m) + 1]] | i in 1..m];

var float: product_rate = product(edge_rate);   % product of all exchange rates in the loop

/* ---------- Objective ---------- */
solve maximize product_rate;

/* ---------- Output ---------- */
output [
  "Loop (indices): ", show(loop), "\n",
  "Product of rates: ", show(product_rate), "\n",
  "Profit (starting with ", show(start), "): ",
  show(start * product_rate - start), "\n"
];