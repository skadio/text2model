% Toy factory planning: minimize number of factories

int: toys_required = 250;
int: operators_available = 16;

int: medium_toys = 50;
int: medium_ops  = 3;

int: small_toys = 35;
int: small_ops  = 2;

% Decision variables: number of factories of each type
var 0..operators_available div medium_ops: medium_factories;
var 0..operators_available div small_ops: small_factories;

% Constraints
constraint medium_toys * medium_factories + small_toys * small_factories >= toys_required;
constraint medium_ops * medium_factories + small_ops * small_factories <= operators_available;

% Objective: minimize total number of factories
solve minimize medium_factories + small_factories;

output [
  "medium_factories=", show(medium_factories), "\n",
  "small_factories=", show(small_factories), "\n",
  "total_factories=", show(medium_factories + small_factories), "\n",
  "total_toys=", show(medium_toys * medium_factories + small_toys * small_factories), "\n",
  "operators_used=", show(medium_ops * medium_factories + small_ops * small_factories), "\n"
];