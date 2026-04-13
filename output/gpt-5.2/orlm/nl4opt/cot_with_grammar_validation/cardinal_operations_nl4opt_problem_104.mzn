% Parameters
int: limo_capacity = 12;
int: bus_capacity = 18;
int: min_people = 400;
int: limo_pct_min = 70; % percent

% Variables
var 0..min_people: L; % number of limousines
var 0..min_people: B; % number of buses

% Constraints
constraint limo_capacity * L + bus_capacity * B >= min_people;

% At least 70% of the vehicles must be limousines:
% L / (L+B) >= 0.70  <=>  100*L >= 70*(L+B)  <=>  30*L >= 70*B
constraint 30 * L >= limo_pct_min * B;

% Objective
solve minimize L + B;