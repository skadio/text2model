% Parameters
int: limo_capacity = 12;
int: bus_capacity = 18;
int: min_people = 400;
int: limo_percent = 70; % at least 70% of vehicles are limousines

% Variables
var 0..ceil(min_people div 1 / limo_capacity): L; % number of limousines
var 0..ceil(min_people div 1 / bus_capacity): B;  % number of buses

% Constraints
constraint limo_capacity * L + bus_capacity * B >= min_people;

% At least 70% limousines: L / (L + B) >= 0.70  <=>  100*L >= 70*(L+B)
constraint 100 * L >= limo_percent * (L + B);

% Objective
solve minimize L + B;