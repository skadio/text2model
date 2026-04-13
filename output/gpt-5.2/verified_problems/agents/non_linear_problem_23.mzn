% Parameters
int: n;                                 % Total number of currencies
int: m;                                 % Number of currencies in the arbitrage loop (loop length)
array[1..n, 1..n] of float: currencies; % Exchange rates: currencies[i,j] = rate from currency i to currency j
array[1..n] of string: currencies_s;    % Names of currencies (for output/display)
float: start;                           % Initial amount in the starting/base currency

% Variables
array[1..m] of var 1..n: loop;          % Sequence of currencies in the arbitrage loop (indices 1..n)
var 1..n: start_currency;               % Starting currency index (equal to loop[1])
var float: final_amount;                % Amount after completing the loop and exchanging back to start
var float: profit;                      % Profit = final_amount - start

% Constraints
% Link the chosen starting currency to the first currency in the loop
constraint start_currency = loop[1];

% Enforce a proper loop: all currencies in the loop are distinct
constraint all_different(loop);

% Compute the final amount after executing the m-step exchange sequence:
% start * Π_{k=1..m-1} rate(loop[k] -> loop[k+1]) * rate(loop[m] -> loop[1])
constraint
  final_amount =
    start
    * product(k in 1..m-1)(currencies[loop[k], loop[k+1]])
    * currencies[loop[m], loop[1]];

% Define profit
constraint profit = final_amount - start;

% Require a profitable loop
constraint profit > 0.0;

% Objective
solve maximize profit;