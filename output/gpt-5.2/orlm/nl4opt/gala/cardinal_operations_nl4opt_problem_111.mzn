% Snow removal truck selection (embedded data, no .dzn needed)

% Data
int: people_available = 30;

int: people_small = 2;
int: people_large = 4;

int: cap_small = 30;
int: cap_large = 50;

int: min_small = 10;
int: min_large = 3;

% Decision variables
var 0..people_available div people_small: small_trucks;
var 0..people_available div people_large: large_trucks;

% Constraints
constraint people_small * small_trucks + people_large * large_trucks <= people_available;

constraint small_trucks >= min_small;
constraint large_trucks >= min_large;

% "small trucks must be twice as much as large trucks"
constraint small_trucks = 2 * large_trucks;

% Objective: maximize total snow transported
var 0..cap_small*(people_available div people_small) + cap_large*(people_available div people_large): total_snow;
constraint total_snow = cap_small * small_trucks + cap_large * large_trucks;

solve maximize total_snow;

output [
  "Small trucks = ", show(small_trucks), "\n",
  "Large trucks = ", show(large_trucks), "\n",
  "Total snow transported = ", show(total_snow), "\n",
  "People used = ", show(people_small*small_trucks + people_large*large_trucks), " / ", show(people_available), "\n"
];