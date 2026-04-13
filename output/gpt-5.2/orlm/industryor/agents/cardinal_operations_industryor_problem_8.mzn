% Parameters
int: nToys = 4;

set of int: TOYS = 1..nToys;

% Toy indices (fixed mapping)
int: TRUCK = 1;
int: AIRPLANE = 2;
int: BOAT = 3;
int: TRAIN = 4;

% Profit per unit for each toy
array[TOYS] of int: profit = [5, 10, 8, 7];

% Resource availability
int: wood_available = 890;
int: steel_available = 500;

% Resource usage per unit toy
array[TOYS] of int: wood_per_unit  = [12, 20, 15, 10];
array[TOYS] of int: steel_per_unit = [ 6,  3,  5,  4];

% Tight per-toy upper bounds implied by resources (for variable bounding)
array[TOYS] of int: max_by_wood  = [wood_available div wood_per_unit[t]  | t in TOYS];
array[TOYS] of int: max_by_steel = [steel_available div steel_per_unit[t] | t in TOYS];
array[TOYS] of int: max_units    = [min(max_by_wood[t], max_by_steel[t]) | t in TOYS];

% Variables
% Units produced of each toy (nonnegative integer, bounded by resource-implied maxima)
array[TOYS] of var 0..max_units[t]: x;

% Whether a toy type is manufactured (1 if any units, 0 otherwise)
array[TOYS] of var 0..1: make;

% Constraints

% Link production quantities to make/no-make binary indicators
constraint
  forall(t in TOYS) (
    x[t] <= max_units[t] * make[t]
  );

% Wood resource capacity
constraint
  sum(t in TOYS) (wood_per_unit[t] * x[t]) <= wood_available;

% Steel resource capacity
constraint
  sum(t in TOYS) (steel_per_unit[t] * x[t]) <= steel_available;

% Logical constraint: If trucks are manufactured, trains are not manufactured
constraint
  make[TRUCK] + make[TRAIN] <= 1;

% Logical constraint: If boats are manufactured, airplanes are also manufactured
constraint
  make[BOAT] <= make[AIRPLANE];

% Production relationship: boats manufactured cannot exceed trains manufactured
constraint
  x[BOAT] <= x[TRAIN];

% Objective
solve maximize sum(t in TOYS) (profit[t] * x[t]);