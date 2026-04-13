% Glacial water transport optimization (all data embedded)

int: small_capacity = 40;
int: large_capacity = 100;

int: max_small_available = 30;
int: max_large_available = 10;

int: max_total_kegs = 25;
int: min_large_required = 5;

% Decision variables: number of kegs used
var 0..max_small_available: small_kegs;
var 0..max_large_available: large_kegs;

% Constraints
constraint small_kegs + large_kegs <= max_total_kegs;
constraint large_kegs >= min_large_required;
constraint small_kegs >= 2 * large_kegs;

% Objective: maximize total liters transported
var int: total_liters = small_capacity * small_kegs + large_capacity * large_kegs;
solve maximize total_liters;

output [
  "small_kegs = ", show(small_kegs), "\n",
  "large_kegs = ", show(large_kegs), "\n",
  "total_kegs = ", show(small_kegs + large_kegs), "\n",
  "total_liters = ", show(total_liters), "\n"
];