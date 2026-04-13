% Military logistics allocation problem (all data embedded)

int: min_total_units = 100;
int: max_combined_strength = 600;

int: strength_x = 5;
int: strength_y = 3;

int: cost_x = 5000; % support points per unit X
int: cost_y = 3000; % support points per unit Y

% Decision variables: whole number of units
var 0..max_combined_strength div strength_x: X;
var 0..max_combined_strength div strength_y: Y;

constraint X + Y >= min_total_units;
constraint strength_x * X + strength_y * Y <= max_combined_strength;

var int: total_support = cost_x * X + cost_y * Y;
solve minimize total_support;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Minimum total support points ($)=", show(total_support), "\n"
];