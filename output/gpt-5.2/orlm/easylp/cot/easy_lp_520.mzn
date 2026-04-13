% Parameters (with values embedded)
int: budget = 10000;
int: cost1 = 500;
int: cost2 = 400;
int: cost3 = 300;

int: rhs1 = 2000;   % for 0.5*x1 - 0.25*x2 >= 2000
int: diff_max = 500; % for x3 - x1 <= 500

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

var 0..(cost1*budget + cost2*budget + cost3*budget): total_cost;

% Constraints
constraint x1 + x2 + x3 <= budget;

% Avoid fractions by multiplying by 4: 2*x1 - x2 >= 8000
constraint 2*x1 - x2 >= 4*rhs1;

constraint x3 - x1 <= diff_max;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;