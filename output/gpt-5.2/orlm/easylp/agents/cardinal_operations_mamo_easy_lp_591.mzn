% Parameters
int: cost_x1 = 50;          % Unit cost for product line x1 ($/unit)
int: cost_x2 = 60;          % Unit cost for product line x2 ($/unit)
int: cost_x3 = 70;          % Unit cost for product line x3 ($/unit)
int: cost_x4 = 80;          % Unit cost for product line x4 ($/unit)

int: max_x1 = 600;          % Maximum production capacity for x1 (units)
int: max_x2 = 400;          % Maximum production capacity for x2 (units)
int: max_x3 = 500;          % Maximum production capacity for x3 (units)
int: max_x4 = 300;          % Maximum production capacity for x4 (units)

int: limit_x1_x2 = 1000;    % Upper bound on combined output x1 + x2
int: limit_2x3_3x4 = 1200;  % Upper bound on 2*x3 + 3*x4
int: min_total = 500;       % Minimum total production across all lines

% Variables
var 0..max_x1: x1;          % Units produced in product line x1 (integer)
var 0..max_x2: x2;          % Units produced in product line x2 (integer)
var 0..max_x3: x3;          % Units produced in product line x3 (integer)
var 0..max_x4: x4;          % Units produced in product line x4 (integer)

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;
                            % Total production cost ($), bounded by max possible cost

% Constraints

% Link total_cost to the linear production cost expression
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Supply/combined capacity constraint for product lines x1 and x2
constraint
  x1 + x2 <= limit_x1_x2;

% Resource constraint involving product lines x3 and x4
constraint
  2 * x3 + 3 * x4 <= limit_2x3_3x4;

% Minimum overall production to meet demand/diversity requirements
constraint
  x1 + x2 + x3 + x4 >= min_total;

% Product mix balance: x1 must exceed half of x3 (avoid fractions by multiplying)
constraint
  2 * x1 > x3;

% Objective
solve minimize total_cost;