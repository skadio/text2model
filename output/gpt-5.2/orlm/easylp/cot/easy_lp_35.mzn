% Parameters (with values embedded)
int: min_total_weighted_investment = 50000;   % 2*stocks + bonds >= 50000
int: max_difference = 20000;                 % stocks - 2*bonds <= 20000
int: cost_stock = 4;
int: cost_bond  = 3;

% Variables
var 0..60000: stocks; % whole units, upper bounds chosen safely from constraints
var 0..60000: bonds;

% Constraints
constraint 2 * stocks + bonds >= min_total_weighted_investment;
constraint stocks - 2 * bonds <= max_difference;

% Objective
solve minimize cost_stock * stocks + cost_bond * bonds;