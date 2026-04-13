% Sand container delivery optimization (all data embedded)

int: people_available = 100;

int: small_people = 1;
int: large_people = 3;

int: small_capacity = 20;
int: large_capacity = 50;

int: min_small = 5;
int: min_large = 3;

% Decision variables: number of containers (nonnegative integers)
var 0..people_available: small;
var 0..people_available: large;

% Constraints
constraint small = 3 * large;                              % small thrice large
constraint small >= min_small;
constraint large >= min_large;
constraint small_people * small + large_people * large <= people_available;

% Objective: maximize total sand delivered
var int: total_sand = small_capacity * small + large_capacity * large;

solve maximize total_sand;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "people_used = ", show(small_people*small + large_people*large), "\n",
  "total_sand = ", show(total_sand), "\n"
];