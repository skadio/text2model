% Parameters
int: cap_high = 10000;
int: cap_low  = 5000;

int: tech_high = 12;
int: tech_low  = 5;

int: demand = 150000;
int: tech_available = 160;

float: max_high_frac = 0.35;
int: min_low = 8;

% Variables
var 0..1000: high;
var 0..1000: low;

% Constraints
constraint cap_high * high + cap_low * low >= demand;
constraint tech_high * high + tech_low * low <= tech_available;

constraint low >= min_low;

% At most 35% of pipes are high-volume: high <= 0.35*(high+low)
% Linearized: 100*high <= 35*(high+low)  -> 65*high <= 35*low
constraint 65 * high <= 35 * low;

% Objective
solve minimize high + low;