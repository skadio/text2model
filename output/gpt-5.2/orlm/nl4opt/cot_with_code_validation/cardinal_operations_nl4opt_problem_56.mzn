% Parameters
int: cap_high = 10000;
int: tech_high = 12;

int: cap_low = 5000;
int: tech_low = 5;

int: demand = 150000;
int: tech_available = 160;

int: min_low = 8;

% Variables
var 0..1000: x_high;  % number of high-volume pipes
var 0..1000: x_low;   % number of low-volume pipes
var 0..2000: total_pipes;

% Constraints
constraint total_pipes = x_high + x_low;

constraint cap_high * x_high + cap_low * x_low >= demand;

constraint tech_high * x_high + tech_low * x_low <= tech_available;

constraint x_low >= min_low;

% At most 35% of pipes can be high-volume:
% x_high / (x_high + x_low) <= 0.35  <=>  100*x_high <= 35*(x_high + x_low)
constraint 100 * x_high <= 35 * (x_high + x_low);

% Objective
solve minimize total_pipes;