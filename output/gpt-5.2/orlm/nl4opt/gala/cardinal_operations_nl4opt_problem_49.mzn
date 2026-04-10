include "globals.mzn";

% Data (embedded from problem description)
int: kids_cap = 100;          % ml per kids bottle
int: adult_cap = 300;         % ml per adult bottle
int: total_ml = 25000;        % available cough syrup (ml)

int: min_kids = 50;           % at least 50 kids bottles
int: adult_to_kids = 3;       % at least 3 times as many adult bottles as kids bottles

% Decision variables
var min_kids..(total_ml div kids_cap): kids;
var 0..(total_ml div adult_cap): adult;

% Constraints
constraint kids_cap * kids + adult_cap * adult <= total_ml;
constraint adult >= adult_to_kids * kids;

% Objective: maximize total number of bottles
var 0..(total_ml div kids_cap + total_ml div adult_cap): total_bottles = kids + adult;

solve maximize total_bottles;

output [
  "kids = ", show(kids), "\n",
  "adult = ", show(adult), "\n",
  "total_bottles = ", show(total_bottles), "\n",
  "used_ml = ", show(kids_cap * kids + adult_cap * adult), "\n"
];