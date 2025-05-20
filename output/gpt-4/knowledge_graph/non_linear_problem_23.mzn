include "globals.mzn";

% Parameters
int: n; % Total number of currencies
int: m; % Number of involved currencies in the arbitrage loop
array[1..n, 1..n] of float: currencies; % Exchange rates between different currencies
array[1..n] of string: currencies_s; % Names of the currencies
float: start; % Initial amount in the base currency for trading

% Variables
array[1..m] of var 1..n: sequence; % Sequence of currencies in the arbitrage loop

% Constraints
constraint forall(i in 1..m-1)(sequence[i] != sequence[i+1]); % No currency can be traded into itself
constraint sequence[1] = sequence[m]; % The arbitrage loop must start and end with the same currency

% Objective
var float: profit = start;
constraint forall(i in 1..m-1)(profit = profit * currencies[sequence[i], sequence[i+1]]);
solve maximize profit - start;

% Output
output ["Arbitrage sequence: "] ++ [currencies_s[sequence[i]] | i in 1..m] ++ ["\nProfit: ", show(profit - start)];