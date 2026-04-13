% Parameters
int: n;                      % total number of currencies
int: m;                      % length of arbitrage loop (number of involved currencies)
array[1..n, 1..n] of float: currencies;   % exchange rates i -> j
array[1..n] of string: currencies_s;      % currency names (not used in optimization)
float: start;                % initial amount in starting currency

% Variables
array[1..m] of var 1..n: loop;            % sequence of currencies in the loop
var 1..n: base;                            % starting/ending currency
array[0..m] of var 1..n: node;             % node[0]=base, node[k]=loop[k], node[m]=base

% Use log formulation to avoid non-linear products:
% maximize start*(exp(sum(log(rate))) - 1) <=> maximize sum(log(rate))
array[1..n, 1..n] of float: lograte = array2d(1..n, 1..n,
  [ ln(currencies[i,j]) | i in 1..n, j in 1..n ]
);
var float: log_gain;

% Constraints
constraint node[0] = base;
constraint forall(k in 1..m)(node[k] = loop[k]);
constraint node[m] = base;

% Ensure a simple cycle over distinct currencies (including base)
constraint all_different(node);

% Disallow self-exchange steps (optional, but typical for arbitrage loops)
constraint forall(k in 0..m-1)(node[k] != node[k+1]);

% Compute log gain along the loop
constraint log_gain = sum(k in 0..m-1)( lograte[node[k], node[k+1]] );

% Enforce profitability: final amount > start  <=>  log_gain > 0
constraint log_gain > 0.0;

% Objective
solve maximize log_gain;