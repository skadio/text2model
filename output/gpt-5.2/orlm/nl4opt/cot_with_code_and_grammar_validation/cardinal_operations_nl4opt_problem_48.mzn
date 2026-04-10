% Parameters
int: cap_motorcycle = 30;
int: cap_sedan = 70;

int: pol_motorcycle = 4;
int: pol_sedan = 15;

int: earn_motorcycle = 100;
int: earn_sedan = 225;

int: pol_limit = 200;          % strictly less than 200
int: demand = 1200;

% Variables
var 0..10000: m;  % motorcycles
var 0..10000: s;  % sedans

% Constraints
constraint
  cap_motorcycle * m + cap_sedan * s >= demand;

constraint
  pol_motorcycle * m + pol_sedan * s <= pol_limit - 1;

% At most 25% of vehicles are motorcycles: m <= 0.25*(m+s) <=> 3m <= s
constraint
  3 * m <= s;

% Objective
solve maximize earn_motorcycle * m + earn_sedan * s;