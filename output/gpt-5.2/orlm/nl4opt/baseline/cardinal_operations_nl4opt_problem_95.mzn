% Dog hospital bone production - minimize meat usage

% Data (embedded)
int: tooth_available = 2000;

int: tooth_small = 10;
int: meat_small  = 12;

int: tooth_large = 15;
int: meat_large  = 15;

int: min_large = 30;          % at least 30 large bones
int: min_small_share_num = 1; % small >= 50% of total => 2*small >= small+large
int: min_small_share_den = 2;

% Decision variables
var 0..(tooth_available div tooth_small): small;
var 0..(tooth_available div tooth_large): large;

% Constraints
constraint tooth_small * small + tooth_large * large <= tooth_available;

% At least 50% small: small >= 0.5*(small+large)  <=>  small >= large
constraint small >= large;

constraint large >= min_large;

% Objective: minimize total meat used
var int: total_meat = meat_small * small + meat_large * large;
solve minimize total_meat;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "total_meat = ", show(total_meat), "\n"
];