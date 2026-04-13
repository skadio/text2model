% Parameters (with values embedded)
int: cap_small = 20;
int: cap_large = 50;
int: students_needed = 500;

% Variables
var 0..25: small_buses;     % upper bound: 25 small buses alone can carry 500
var 0..10: large_buses;     % upper bound: 10 large buses alone can carry 500
var 0..35: total_buses;     % total buses <= 25+10

% Constraints
constraint total_buses = small_buses + large_buses;

% At least 500 students transported
constraint cap_small * small_buses + cap_large * large_buses >= students_needed;

% At most 20% of buses are large: large_buses / total_buses <= 0.2
% Avoid division: 5 * large_buses <= total_buses (also handles total_buses = 0 safely)
constraint 5 * large_buses <= total_buses;

% Objective
solve minimize total_buses;