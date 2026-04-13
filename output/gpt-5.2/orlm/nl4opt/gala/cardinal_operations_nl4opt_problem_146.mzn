% Pizza production planning: minimize total baking time
% All data embedded as per instructions.

include "globals.mzn";

% Parameters
int: dough_req_large = 12;
int: top_req_large   = 5;
int: time_large      = 12;

int: dough_req_med   = 8;
int: top_req_med     = 4;
int: time_med        = 8;

int: min_dough = 10000;
int: min_top   = 4400;

int: min_med   = 200;

% Decision variables: number of pizzas (nonnegative integers)
% Upper bounds chosen safely large enough to allow feasibility.
var 0..20000: L; % large pizzas
var 0..20000: M; % medium pizzas

% Resource minimums
constraint dough_req_large * L + dough_req_med * M >= min_dough;
constraint top_req_large   * L + top_req_med   * M >= min_top;

% Demand / policy constraints
constraint M >= min_med;
constraint L >= 2 * M;

% Objective: minimize total baking time
var 0..intmax: total_time = time_large * L + time_med * M;

solve minimize total_time;

output [
  "Large pizzas (L) = ", show(L), "\n",
  "Medium pizzas (M) = ", show(M), "\n",
  "Total baking time = ", show(total_time), " minutes\n",
  "Total dough used = ", show(dough_req_large * L + dough_req_med * M), "\n",
  "Total toppings used = ", show(top_req_large * L + top_req_med * M), "\n"
];