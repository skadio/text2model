% Parameters (with values embedded)
int: budget = 5000;

% Effectiveness coefficients (scaled by 2 to avoid halves)
int: eff1_x1 = 10;   % 2*(5)
int: eff1_x2 = -5;   % 2*(-2.5)
int: eff1_min = 2000; % 2*1000

int: eff2_x2 = 6;    % 2*(3)
int: eff2_x3 = 9;    % 2*(4.5)
int: eff2_max = 8000; % 2*4000

% Balance constraint (scaled by 2): 2*x1 - 3*x2 = 2*x3
int: bal_x1 = 2;
int: bal_x2 = -3;
int: bal_x3 = -2;

% Costs
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

var 0..(c1*budget + c2*budget + c3*budget): total_cost;

% Constraints
constraint x1 + x2 + x3 <= budget;

constraint eff1_x1 * x1 + eff1_x2 * x2 >= eff1_min;

constraint eff2_x2 * x2 + eff2_x3 * x3 <= eff2_max;

constraint bal_x1 * x1 + bal_x2 * x2 + bal_x3 * x3 = 0;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];