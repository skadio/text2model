% Detect arbitrage loops in currency exchange markets

% --------------------
% Parameters (from .dzn)
% --------------------
int: n;                                  % total number of currencies
int: m;                                  % number of currencies in the loop
array[1..n, 1..n] of float: currencies;  % exchange rates i -> j
array[1..n] of string: currencies_s;     % currency names (not used in optimization)
float: start;                            % initial amount in base currency

% --------------------
% Variables
% --------------------
array[1..m] of var 1..n: loop;           % sequence of currencies in the loop
array[1..m] of var float: amt;           % amount held after each exchange
var float: final_amt;
var float: profit;

% --------------------
% Constraints
% --------------------
constraint m >= 2;
constraint start >= 0.0;

% simple cycle: use distinct currencies in the loop
constraint alldifferent(loop);

% initial amount
constraint amt[1] = start;

% propagate amounts along the loop
constraint forall(k in 1..m-1) (
  amt[k+1] = amt[k] * currencies[loop[k], loop[k+1]]
);

% close the loop (exchange back to the first currency)
constraint final_amt = amt[m] * currencies[loop[m], loop[1]];

% profit
constraint profit = final_amt - start;

% --------------------
% Objective
% --------------------
solve maximize profit;