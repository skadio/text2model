% Sports equipment production optimization (basketballs and footballs)

% Data (embedded as requested)
int: mat_avail = 1500;
int: hrs_avail = 750;

int: mat_basket = 5;
int: hrs_basket = 1;

int: mat_football = 3;
int: hrs_football = 2;

int: min_football = 50;
int: basket_to_football_ratio = 3; % basketballs >= 3 * footballs

% Decision variables
var 0..mat_avail div mat_basket: B;  % number of basketballs
var 0..mat_avail div mat_football: F; % number of footballs

% Constraints
constraint mat_basket * B + mat_football * F <= mat_avail;
constraint hrs_basket * B + hrs_football * F <= hrs_avail;

constraint B >= basket_to_football_ratio * F;
constraint F >= min_football;

% Objective: maximize total items produced
solve maximize B + F;

output [
  "Basketballs = ", show(B), "\n",
  "Footballs   = ", show(F), "\n",
  "Total       = ", show(B + F), "\n",
  "Materials used = ", show(mat_basket * B + mat_football * F), " / ", show(mat_avail), "\n",
  "Hours used     = ", show(hrs_basket * B + hrs_football * F), " / ", show(hrs_avail), "\n"
];