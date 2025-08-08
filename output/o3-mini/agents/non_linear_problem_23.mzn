% Arbitrage loop detection in currency exchange markets
% Data parameters (supplied via a separate .dzn file)
int: n;                             % Total number of currencies
int: m;                             % Number of exchanges in the arbitrage loop
array[1..n, 1..n] of float: currencies; % Exchange rates: rate from currency i to j
array[1..n] of string: currencies_s; % Names of the currencies
float: start;                       % Initial amount in the base currency

% Decision Variables
% path represents the sequence of currencies visited.
% We assume that currency 1 is the base currency:
array[1..m+1] of var 1..n: path;

% amount[i] holds the amount of money after i trades.
array[1..m+1] of var float: amount;

% Constraints

% Force the arbitrage loop to start and end at the base currency (assumed to be currency 1)
constraint path[1] = 1;
constraint path[m+1] = 1;

% Initialize the starting amount.
constraint amount[1] = start;

% Propagate the exchanged amount along the loop.
% At each step, the new amount equals the previous amount multiplied by the corresponding exchange rate.
constraint
  forall(i in 1..m) (
    amount[i+1] = amount[i] * currencies[path[i], path[i+1]]
  );

% The arbitrage loop should be profitable, i.e., the final amount is greater than the starting amount.
constraint amount[m+1] > start;

% Objective: Maximize the total profit gained by the arbitrage loop.
% Profit = final amount - starting amount.
solve maximize amount[m+1] - start;

% Output the arbitrage sequence along with the corresponding currency names and the profit.
output [
  "Arbitrage loop (by currency indices): " , show(path), "\n",
  "Arbitrage loop (by currency names): ",
    show([ currencies_s[path[i]] | i in 1..m+1 ]), "\n",
  "Starting amount: ", show(start), "\n",
  "Final amount: ", show(amount[m+1]), "\n",
  "Profit: ", show(amount[m+1] - start), "\n"
];