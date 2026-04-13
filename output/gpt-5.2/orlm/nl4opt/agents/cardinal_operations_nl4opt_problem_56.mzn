% Parameters
int: high_volume_gallons = 10000;          % Gallons/day per high-volume pipe
int: low_volume_gallons  = 5000;           % Gallons/day per low-volume pipe

int: techs_per_high = 12;                  % Technicians required per high-volume pipe
int: techs_per_low  = 5;                   % Technicians required per low-volume pipe

int: demand_gallons = 150000;              % Minimum daily demand (gallons)
int: available_techs = 160;                % Available technicians

float: max_high_fraction = 0.35;           % (Not used directly; linearized constraint below)
int: min_low_pipes = 8;                    % Minimum number of low-volume pipes

% Safe upper bounds for decision variables (from demand alone)
int: max_high_pipes = (demand_gallons + high_volume_gallons - 1) div high_volume_gallons;
int: max_low_pipes  = (demand_gallons + low_volume_gallons  - 1) div low_volume_gallons;


% Variables
var 0..max_high_pipes: num_high_pipes;                 % Number of high-volume pipes
var 0..max_low_pipes:  num_low_pipes;                  % Number of low-volume pipes
var 0..(max_high_pipes + max_low_pipes): total_pipes;  % Total number of pipes


% Constraints
% Total pipes definition (linking constraint)
constraint total_pipes = num_high_pipes + num_low_pipes;

% Meet or exceed daily demand in gallons
constraint high_volume_gallons * num_high_pipes
         + low_volume_gallons  * num_low_pipes
         >= demand_gallons;

% Do not exceed available technicians
constraint techs_per_high * num_high_pipes
         + techs_per_low  * num_low_pipes
         <= available_techs;

% High-volume pipe fraction limit: num_high_pipes <= 0.35 * total_pipes
% Linearized to avoid floats: 100*h <= 35*(h+l) -> 65*h <= 35*l
constraint 65 * num_high_pipes <= 35 * num_low_pipes;

% Minimum number of low-volume pipes
constraint num_low_pipes >= min_low_pipes;


% Objective
solve minimize total_pipes;