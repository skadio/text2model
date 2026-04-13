% Grape crate optimization (all data embedded)

int: cap_small = 200;
int: cap_large = 500;

int: max_small = 100;
int: max_large = 50;

int: max_total_crates = 60;
int: min_large = 10;

% Decision variables
var 0..max_small: small;
var 0..max_large: large;

% Constraints
constraint small >= 3 * large;                 % at least 3 times as many small as large
constraint small + large <= max_total_crates;   % truck capacity in crates
constraint large >= min_large;                  % must use at least 10 large crates

% Objective: maximize total grapes transported
var int: total_grapes = cap_small * small + cap_large * large;
solve maximize total_grapes;

output [
  "small_crates = ", show(small), "\n",
  "large_crates = ", show(large), "\n",
  "total_grapes = ", show(total_grapes), "\n"
];