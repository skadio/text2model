% Parameters (with values embedded)
int: limo_cap = 12;
int: bus_cap  = 18;
int: min_people = 400;
int: min_limo_percent = 70;

% Variables
var 0..400: L;  % number of limousines
var 0..400: B;  % number of buses

% Constraints
constraint limo_cap * L + bus_cap * B >= min_people;

% At least 70% of vehicles are limousines: L/(L+B) >= 0.7
% Cross-multiply to avoid division: 100*L >= 70*(L+B)
constraint 100 * L >= min_limo_percent * (L + B);

% Objective
solve minimize L + B;