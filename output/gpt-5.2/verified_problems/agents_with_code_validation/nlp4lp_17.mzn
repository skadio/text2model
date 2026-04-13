% Oil refinery process selection (continuous LP)
% Note: Gecode has limited support for float linear expressions and can raise
% "Float::linear: Number out of limits". Use an LP-capable solver (e.g., COIN-BC)
% via --solver coin-bc.

% Parameters
int: O; % Number of crude oil options (resource types)
int: P; % Number of products / price points
int: L; % Number of processes

set of int: OPTIONS = 1..O;
set of int: PRODUCTS = 1..P;
set of int: PROCESSES = 1..L;

array[OPTIONS] of float: Allocated;
array[PRODUCTS] of float: Price;

array[PROCESSES, OPTIONS] of float: Input;
array[PROCESSES, PRODUCTS] of float: Output;

array[PROCESSES] of float: Cost;

% Decision variables (continuous, nonnegative)
array[PROCESSES] of var float: run;

% Constraints: resource availability
constraint
  forall(o in OPTIONS) (
    sum(p in PROCESSES) (Input[p, o] * run[p]) <= Allocated[o]
  );

% Nonnegativity
constraint forall(p in PROCESSES) (run[p] >= 0.0);

% Objective: maximize profit = revenue - process costs
var float: profit =
  sum(p in PROCESSES, pr in PRODUCTS) (Price[pr] * Output[p, pr] * run[p])
  - sum(p in PROCESSES) (Cost[p] * run[p]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "run=", show(run), "\n"
];