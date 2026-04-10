% Rice transport with medium and large carts

int: horses_available = 60;

int: horses_medium = 2;
int: horses_large  = 4;

int: cap_medium = 30;
int: cap_large  = 70;

int: min_medium = 5;
int: min_large  = 5;

% Decision variables
var 0..horses_available div horses_medium: m; % number of medium carts
var 0..horses_available div horses_large:  l; % number of large carts

% Constraints
constraint horses_medium * m + horses_large * l <= horses_available;
constraint m = 3 * l;
constraint m >= min_medium;
constraint l >= min_large;

% Objective: maximize transported rice
var int: total_rice = cap_medium * m + cap_large * l;
solve maximize total_rice;

output [
  "medium_carts = ", show(m), "\n",
  "large_carts  = ", show(l), "\n",
  "total_rice_kg = ", show(total_rice), "\n"
];