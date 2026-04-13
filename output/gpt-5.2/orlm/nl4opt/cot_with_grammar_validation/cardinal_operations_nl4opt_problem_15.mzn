% Parameters
int: demand = 320;

int: cap_ambulance = 20;
int: cap_van = 15;

int: cost_ambulance = 820;
int: cost_van = 550;

float: max_van_fraction = 0.60;

% Variables
var 0..ceil(demand / cap_ambulance): amb_shifts;
var 0..ceil(demand / cap_van): van_shifts;

var 0..(cost_ambulance * ceil(demand / cap_ambulance) + cost_van * ceil(demand / cap_van)): total_cost;

% Constraints
constraint cap_ambulance * amb_shifts + cap_van * van_shifts >= demand;

% van_shifts <= 0.60 * (amb_shifts + van_shifts)
% Implemented without floats: (1 - 0.60)*van <= 0.60*amb  => 0.40*van <= 0.60*amb => 2*van <= 3*amb
constraint 2 * van_shifts <= 3 * amb_shifts;

constraint total_cost = cost_ambulance * amb_shifts + cost_van * van_shifts;

% Objective
solve minimize total_cost;