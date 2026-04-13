% Vine bottles optimization (all data embedded)

int: total_vine_ml = 100000;
int: cap_vintage = 500;
int: cap_regular = 750;

int: min_vintage = 10;
int: regular_at_least_factor = 4; % regular >= 4 * vintage

% Decision variables: number of bottles
var 0..(total_vine_ml div cap_vintage): vintage;
var 0..(total_vine_ml div cap_regular): regular;

% Constraints
constraint vintage >= min_vintage;
constraint regular >= regular_at_least_factor * vintage;

% Total vine used cannot exceed available
constraint cap_vintage * vintage + cap_regular * regular <= total_vine_ml;

% Objective: maximize total number of bottles produced
var 0..(total_vine_ml div min(cap_vintage, cap_regular)): total_bottles;
constraint total_bottles = vintage + regular;

solve maximize total_bottles;

output [
  "vintage = ", show(vintage), "\n",
  "regular = ", show(regular), "\n",
  "total_bottles = ", show(total_bottles), "\n",
  "vine_used_ml = ", show(cap_vintage * vintage + cap_regular * regular), "\n"
];