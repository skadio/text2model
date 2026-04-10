% Parameters
% Sets / indices
set of int: PRODUCTS = 1..3;      % 1=I, 2=II, 3=III
set of int: MACHINES = 1..5;      % 1=A1, 2=A2, 3=B1, 4=B2, 5=B3
set of int: A_MACHINES = 1..2;    % 1=A1, 2=A2
set of int: B_MACHINES = 3..5;    % 3=B1, 4=B2, 5=B3

% Processing time (machine-hours per unit); 0 means "not allowed / not applicable"
array[MACHINES, PRODUCTS] of int: proc_time = array2d(MACHINES, PRODUCTS,
[
  5, 10,  0,   % A1 times for products I, II, III
  7,  9, 12,   % A2
  6,  8,  0,   % B1
  4,  0, 11,   % B2
  7,  0,  0    % B3
]);

% Effective machine hours available
array[MACHINES] of int: avail_hours = [6000, 10000, 4000, 7000, 4000];

% Operating cost at full capacity (Yuan) for each machine
array[MACHINES] of float: full_capacity_cost = [300.0, 321.0, 250.0, 783.0, 200.0];

% Raw material cost (Yuan/unit) by product
array[PRODUCTS] of float: raw_cost = [0.25, 0.35, 0.50];

% Sales price (Yuan/unit) by product
array[PRODUCTS] of float: unit_price = [1.25, 2.00, 2.80];

% Derived: operating cost per hour for each machine (Yuan/hour)
array[MACHINES] of float: op_cost_per_hour =
  [ full_capacity_cost[m] / int2float(avail_hours[m]) | m in MACHINES ];

% Derived: unit margin excluding machine operating costs (Yuan/unit)
array[PRODUCTS] of float: unit_margin = [ unit_price[p] - raw_cost[p] | p in PRODUCTS ];


% Variables
% Units produced of each product (integer, nonnegative)
array[PRODUCTS] of var int: produce_units;

% Units of each product assigned to each machine (integer, nonnegative)
% (Represents "how many units of product p are processed on machine m")
array[MACHINES, PRODUCTS] of var int: units_on_machine;

% Machine hours used (continuous, nonnegative) on each machine
array[MACHINES] of var float: hours_used;

% Total profit (Yuan)
var float: profit;


% Constraints
% Basic bounds / feasibility constraints for variables
constraint forall(p in PRODUCTS) (produce_units[p] >= 0);

constraint forall(m in MACHINES, p in PRODUCTS) (
  units_on_machine[m,p] >= 0 /\
  (proc_time[m,p] = 0 -> units_on_machine[m,p] = 0)
);

constraint forall(m in MACHINES) (
  hours_used[m] >= 0.0 /\
  hours_used[m] <= int2float(avail_hours[m])
);

% --- Flow conservation: each product must complete process A exactly once ---
constraint forall(p in PRODUCTS) (
  sum(m in A_MACHINES)(units_on_machine[m,p]) = produce_units[p]
);

% --- Flow conservation: each product must complete process B exactly once ---
constraint forall(p in PRODUCTS) (
  sum(m in B_MACHINES)(units_on_machine[m,p]) = produce_units[p]
);

% --- Machine-hour accounting: define hours used on each machine from assigned units ---
constraint forall(m in MACHINES) (
  hours_used[m] = sum(p in PRODUCTS)(int2float(units_on_machine[m,p] * proc_time[m,p]))
);

% --- Profit definition: revenue - raw material cost - machine operating costs ---
constraint
  profit =
    sum(p in PRODUCTS)(int2float(produce_units[p]) * unit_margin[p])
    - sum(m in MACHINES)(hours_used[m] * op_cost_per_hour[m]);


% Objective
solve maximize profit;