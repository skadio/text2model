% Parameters
int: total_patients = 320;

int: cap_amb = 20;          % patients per shift (type II ambulance)
int: cap_van = 15;          % patients per shift (hospital van)

int: cost_amb = 820;        % $ per shift
int: cost_van = 550;        % $ per shift

% Variables
var 0..total_patients: x_amb;   % number of ambulance shifts
var 0..total_patients: x_van;   % number of van shifts

% Constraints
constraint cap_amb * x_amb + cap_van * x_van >= total_patients;

% At most 60% of all shifts are vans: x_van <= 0.6*(x_amb + x_van)
% Multiply by 10 to keep integers: 10*x_van <= 6*(x_amb + x_van) => 4*x_van <= 6*x_amb
constraint 4 * x_van <= 6 * x_amb;

% Objective
solve minimize cost_amb * x_amb + cost_van * x_van;