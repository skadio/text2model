% Florist bouquet transport optimization

int: flowers_small = 5;
int: flowers_large = 10;

int: max_small = 80;
int: max_large = 50;
int: max_total_bouquets = 70;
int: min_large = 20;

% Decision variables
var 0..max_small: small;
var 0..max_large: large;

% Constraints
constraint small + large <= max_total_bouquets;
constraint large >= min_large;
constraint small >= 2 * large;

% Objective: maximize total flowers transported
var int: total_flowers = flowers_small * small + flowers_large * large;
solve maximize total_flowers;

output [
  "small_bouquets = ", show(small), "\n",
  "large_bouquets = ", show(large), "\n",
  "total_bouquets = ", show(small + large), "\n",
  "total_flowers  = ", show(total_flowers), "\n"
];