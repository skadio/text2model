include "globals.mzn";

% Data (embedded from the description)
int: c1 = 10;
int: c2 = 15;
int: c3 = 12;
int: c4 = 20;

% Integer decision variables: weekly hours for each group
% NOTE: The description says each group has specific bounds, but no numeric bounds are provided.
% We therefore use a safe nonnegative domain and rely on the given constraints to bound the search.
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

% Constraints
constraint x1 + x2 <= 8;
constraint x3 + x4 <= 10;
constraint x1 + x3 >= 5;
constraint x2 + x4 >= 6;

% Objective: minimize total fatigue score
var 0..100000: fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "fatigue=", show(fatigue), "\n",
  "rounded_fatigue=", show(fatigue), "\n"
];