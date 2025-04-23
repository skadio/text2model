include "globals.mzn";

% Parameters
int: n; % Total number of currencies
int: m; % Number of involved currencies in the arbitrage loop
array[1..n, 1..n] of float: currencies; % Exchange rates between different currencies
array[1..n] of string: currencies_s; % Names of the currencies
float: start; % Initial amount in the base currency for trading

% Decision variables
array[1..m] of var 1..n: sequence; % Sequence of currency exchanges

% Constraints
constraint forall(i in 1..m-1)(currencies[sequence[i], sequence[i+1]] > 0);
constraint currencies[sequence[m], sequence[1]] > 0;

% Objective function
var float: profit = start;
constraint forall(i in 1..m-1)(profit = profit * currencies[sequence[i], sequence[i+1]]);
constraint profit = profit * currencies[sequence[m], sequence[1]];
constraint profit > start;

% Maximize profit
solve maximize profit;

% Output
output ["Arbitrage loop: "] ++ [currencies_s[sequence[i]] | i in 1..m] ++ ["\nProfit: ", show(profit)];