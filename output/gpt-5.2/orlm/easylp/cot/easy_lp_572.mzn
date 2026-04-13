% Parameters (with values embedded)
int: total_resource_limit = 100;

int: cost_x1 = 50000;
int: cost_x2 = 70000;
int: cost_x3 = 60000;

int: x1_min = 10; int: x1_max = 50;
int: x2_min = 20; int: x2_max = 70;
int: x3_min = 0;  int: x3_max = 40;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_resource_limit;

% (1/2)*x1 + (6/10)*x3 >= (7/10)*x2 + 20
% Multiply by 10 to avoid decimals: 5*x1 + 6*x3 >= 7*x2 + 200
constraint 5*x1 + 6*x3 >= 7*x2 + 200;

% (8/10)*x2 + (9/10)*x3 should not surpass by more than 30 units what's been taken away from x1:
% interpret as (8/10)*x2 + (9/10)*x3 - (1)*x1 <= 30
% Multiply by 10: 8*x2 + 9*x3 - 10*x1 <= 300
constraint 8*x2 + 9*x3 - 10*x1 <= 300;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;