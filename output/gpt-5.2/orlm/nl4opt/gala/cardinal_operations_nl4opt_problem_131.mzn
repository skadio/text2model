% Sore throat treatment: minimize sugar intake
% Data embedded as requested.

% To avoid decimals, scale all quantities by 10.
% Syrup 1: throat 5, lungs 4, sugar 5
% Syrup 2: throat 2, lungs 5, sugar 3
int: TMAX = 50;  % at most 5.0 throat medicine
int: LMIN = 40;  % at least 4.0 lungs medicine

int: t1 = 5;  int: l1 = 4;  int: s1 = 5;
int: t2 = 2;  int: l2 = 5;  int: s2 = 3;

% Decision variables: servings (nonnegative integers)
% Upper bounds are safe from throat constraint: t1*x1 + t2*x2 <= 50
var 0..10: x1;  % max if only syrup1: 50/5 = 10
var 0..25: x2;  % max if only syrup2: 50/2 = 25

% Constraints
constraint t1 * x1 + t2 * x2 <= TMAX;
constraint l1 * x1 + l2 * x2 >= LMIN;

% Objective: minimize sugar (scaled by 10 as well)
var 0..1000: sugar = s1 * x1 + s2 * x2;

solve minimize sugar;

output [
  "Servings syrup1 = ", show(x1), "\n",
  "Servings syrup2 = ", show(x2), "\n",
  "Total throat medicine = ", show(t1*x1 + t2*x2), " (scaled by 10)\n",
  "Total lungs medicine = ", show(l1*x1 + l2*x2), " (scaled by 10)\n",
  "Total sugar = ", show(sugar), " (scaled by 10)\n"
];