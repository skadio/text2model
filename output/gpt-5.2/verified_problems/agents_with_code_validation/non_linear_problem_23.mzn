include "globals.mzn";

% Parameters
int: n;                                   % Total number of currencies
int: m;                                   % Number of currencies in the arbitrage loop (loop length)
array[1..n, 1..n] of float: currencies;   % Exchange rates: currencies[i,j] = amount of j obtained for 1 unit of i
array[1..n] of string: currencies_s;      % Names of the currencies (for reporting)
float: start;                             % Initial amount in the starting (base) currency

% Variables
array[1..m] of var 1..n: loop;            % Sequence of currencies in the arbitrage loop (indices)
var 1..n: base_currency;                  % Starting currency of the loop (index)
var float: final_amount;                  % Amount after executing the full loop from 'start'
var float: profit;                        % Profit = final_amount - start

% Constraints
% --- Loop structure constraints ---
constraint loop[1] = base_currency;

% Ensure we have a proper loop by not repeating currencies within the loop positions.
constraint all_different(loop);

% --- Financial computation constraints ---
constraint
  final_amount =
    start *
    product(k in 1..m-1)(currencies[loop[k], loop[k+1]]) *
    currencies[loop[m], base_currency];

constraint profit = final_amount - start;

% --- Arbitrage validity constraint ---
constraint profit > 0.0;

% Objective
solve maximize profit;