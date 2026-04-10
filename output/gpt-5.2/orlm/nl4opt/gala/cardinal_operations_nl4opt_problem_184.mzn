include "globals.mzn";

% Data (embedded from problem statement)
int: horses_available = 60;

int: horses_medium = 2;
int: horses_large  = 4;

int: kg_medium = 30;
int: kg_large  = 70;

int: min_medium = 5;
int: min_large  = 5;

% Decision variables
var min_medium..horses_available div horses_medium: medium_carts;
var min_large..horses_available div horses_large: large_carts;

% Constraints
constraint horses_medium * medium_carts + horses_large * large_carts <= horses_available;
constraint medium_carts = 3 * large_carts;

% Objective: maximize transported rice
var int: total_kg = kg_medium * medium_carts + kg_large * large_carts;

solve maximize total_kg;

output [
  "Medium carts = ", show(medium_carts), "\n",
  "Large carts  = ", show(large_carts), "\n",
  "Total rice (kg) = ", show(total_kg), "\n",
  "Horses used = ", show(horses_medium * medium_carts + horses_large * large_carts),
  " / ", show(horses_available), "\n"
];