% Parameters
int: cost_house = 400000;
int: cost_apartment = 600000;

int: min_value_units = 500;     % 1.5*x + 2*y >= 500
int: max_work_units = 300;      % 0.75*x + 1*y <= 300

% Scale to avoid fractions: multiply constraints by 4
int: scale = 4;

% Variables
var 0..2000: x;   % houses
var 0..2000: y;   % apartments
var 0..2000000000: total_investment;

% Constraints
constraint 6*x + 8*y >= scale * min_value_units;   % 4*(1.5x + 2y) >= 4*500  -> 6x + 8y >= 2000
constraint 3*x + 4*y <= scale * max_work_units;    % 4*(0.75x + y) <= 4*300   -> 3x + 4y <= 1200

constraint total_investment = cost_house * x + cost_apartment * y;

% Objective
solve minimize total_investment;