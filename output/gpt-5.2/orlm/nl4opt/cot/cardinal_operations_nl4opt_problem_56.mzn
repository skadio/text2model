% Parameters (with values embedded)
int: demand = 150000;
int: tech_available = 160;

int: vol_high = 10000;
int: vol_low  = 5000;

int: tech_high = 12;
int: tech_low  = 5;

int: min_low = 8;

% Upper bound on pipe counts derived from demand (if minimizing pipes, never need more than demand/min_volume)
int: max_pipes = demand div min(vol_high, vol_low) + 100; % safe finite bound

% Variables
var 0..max_pipes: n_high;
var 0..max_pipes: n_low;
var 0..2*max_pipes: n_total;

% Constraints
constraint n_total = n_high + n_low;

% Meet demand
constraint vol_high * n_high + vol_low * n_low >= demand;

% Technician availability
constraint tech_high * n_high + tech_low * n_low <= tech_available;

% At most 35% of pipes are high-volume: n_high <= 0.35 * (n_high + n_low)
% Implemented without fractions: 100*n_high <= 35*(n_high+n_low)  <=> 65*n_high <= 35*n_low
constraint 65 * n_high <= 35 * n_low;

% Minimum number of low-volume pipes
constraint n_low >= min_low;

% Objective
solve minimize n_total;