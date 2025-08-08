% Parameters
int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

% Variables
array[1..m] of var 1..n: seq;
array[1..m-1] of var float: rate;
array[1..m-1] of var float: log_rate;
var float: last_rate;
var float: last_log;
var float: profit_log;
var float: profit;

% Constraints
constraint
  all_different(seq);

constraint
  forall(i in 1..m-1) (
    element(currencies, seq[i], seq[i+1], rate[i]) /\
    log_rate[i] = log(rate[i])
  );

constraint
  element(currencies, seq[m], seq[1], last_rate) /\
  last_log = log(last_rate);

constraint
  profit_log = sum(log_rate) + last_log;

constraint
  profit = start * exp(profit_log) - start;

constraint
  profit >= 0.0;

% Objective
solve maximize profit;