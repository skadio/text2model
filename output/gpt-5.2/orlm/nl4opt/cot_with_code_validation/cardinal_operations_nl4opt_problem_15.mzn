% Parameters
int: demand = 320;

int: cap_amb = 20;
int: cap_van = 15;

int: cost_amb = 820;
int: cost_van = 550;

float: max_van_frac = 0.6;

% Variables
var 0..demand: amb_shifts;
var 0..demand: van_shifts;

% Constraints
constraint cap_amb * amb_shifts + cap_van * van_shifts >= demand;

% At most 60% of all shifts can be vans: van_shifts <= 0.6*(amb_shifts+van_shifts)
% Use integer-safe form: 10*van <= 6*(amb+van)  <=> 4*van <= 6*amb
constraint 4 * van_shifts <= 6 * amb_shifts;

% Objective
solve minimize cost_amb * amb_shifts + cost_van * van_shifts;