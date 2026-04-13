% Parameters (with values embedded)
int: luggage_per_4w = 60;
int: pollutant_per_4w = 30;
int: luggage_per_3w = 40;
int: pollutant_per_3w = 15;

int: min_luggage = 1000;
int: max_pollutant = 430;

% Upper bounds derived from constraints (safe finite bounds)
int: max_4w = max_pollutant div pollutant_per_4w; % 430 div 30 = 14
int: max_3w = max_pollutant div pollutant_per_3w; % 430 div 15 = 28

% Variables
var 0..max_4w: x4;  % number of 4-wheelers
var 0..max_3w: x3;  % number of 3-wheelers
var 0..(max_4w + max_3w): total_vehicles;

% Constraints
constraint luggage_per_4w * x4 + luggage_per_3w * x3 >= min_luggage;
constraint pollutant_per_4w * x4 + pollutant_per_3w * x3 <= max_pollutant;
constraint total_vehicles = x4 + x3;

% Objective
solve minimize total_vehicles;