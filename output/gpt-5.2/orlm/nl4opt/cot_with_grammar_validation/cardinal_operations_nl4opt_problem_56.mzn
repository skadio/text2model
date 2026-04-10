% Parameters
int: high_volume = 10000;
int: low_volume  = 5000;

int: tech_high = 12;
int: tech_low  = 5;

int: demand = 150000;
int: tech_available = 160;

float: max_high_fraction = 0.35;
int: min_low_pipes = 8;

% Variables
var 0..1000: H;              % number of high-volume pipes
var min_low_pipes..1000: L;  % number of low-volume pipes

var 0..2000: total_pipes = H + L;

% Constraints
constraint high_volume * H + low_volume * L >= demand;

constraint tech_high * H + tech_low * L <= tech_available;

% At most 35% of pipes can be high-volume:
% H / (H+L) <= 0.35  <=>  100*H <= 35*(H+L)
constraint 100 * H <= 35 * (H + L);

constraint L >= min_low_pipes;

% Objective
solve minimize total_pipes;