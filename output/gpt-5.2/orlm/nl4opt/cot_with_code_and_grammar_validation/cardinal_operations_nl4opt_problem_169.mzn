% Parameters
int: guests_needed = 80;
int: cap_golf = 4;
int: cap_pull = 1;
int: pct_golf_max_num = 60;
int: pct_golf_max_den = 100;

% Variables
var 0..guests_needed: golf;
var 0..guests_needed: pull;
var 0..2*guests_needed: total;

% Constraints
constraint total = golf + pull;

constraint cap_golf * golf + cap_pull * pull >= guests_needed;

% At most 60% of carts are golf carts: golf/total <= 60/100  -> 100*golf <= 60*total
constraint pct_golf_max_den * golf <= pct_golf_max_num * total;

% Objective
solve minimize total;