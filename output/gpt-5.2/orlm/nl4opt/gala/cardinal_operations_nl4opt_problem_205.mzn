include "globals.mzn";

% Data (embedded)
int: pop_audience = 100;
int: pop_days     = 2;

int: rb_audience  = 240;
int: rb_days      = 4;

int: min_audience = 10000;
int: max_days     = 180;

% Decision variables: number of concerts of each type
var 0..(max_days div pop_days): pop;
var 0..(max_days div rb_days): rb;

% Total concerts
var 0..(max_days div 1): total = pop + rb;

% Constraints
constraint pop_audience * pop + rb_audience * rb >= min_audience;
constraint pop_days * pop + rb_days * rb <= max_days;

% At most 40% of concerts can be R&B:
% rb <= 0.4*(pop+rb)  <=>  5*rb <= 2*(pop+rb)  <=>  3*rb <= 2*pop
constraint 3 * rb <= 2 * pop;

% Objective: minimize total number of concerts
solve minimize total;

output [
  "pop = ", show(pop), "\n",
  "rb  = ", show(rb), "\n",
  "total = ", show(total), "\n",
  "audience = ", show(pop_audience*pop + rb_audience*rb), "\n",
  "days = ", show(pop_days*pop + rb_days*rb), "\n"
];