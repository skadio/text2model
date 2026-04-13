include "globals.mzn";

int: n;                          % Total number of currencies
int: m;                          % Number of involved currencies in the arbitrage loop
array[1..n, 1..n] of float: currencies; % Exchange rates between currencies
array[1..n] of string: currencies_s;    % Names of the currencies
float: start;                    % Initial amount in the base currency for trading

% Variables
array[1..m] of var 1..n: sequence; % Sequence of currencies in the arbitrage loop

% Constraints
constraint all_different(sequence); % Ensure all currencies in the loop are different

% Objective: Maximize profit
var float: profit = start * (prod(i in 1..m)(currencies[sequence[i], sequence[(i mod m) + 1]])) - start;

% Solve
solve maximize profit;

% Output
output [ "Arbitrage Sequence = ", show(sequence), "\nProfit = ", show(profit), "\n" ];