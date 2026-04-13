% Parameters (with values embedded)
int: cost1 = 50;
int: cost2 = 75;
int: cost3 = 120;

int: total_resource_max = 500;

int: eff_min = 1000;
int: eff1 = 5;
int: eff2 = 10;

int: diff_max = 300;
% interpret "twice and a half" as 2.5 * X3, so 2.5*X3 - X1 <= 300
% multiply by 2 to keep integer arithmetic: 5*X3 - 2*X1 <= 600
int: diff3_coeff = 5;
int: diff1_coeff = 2;
int: diff_rhs = 600;

% Specific bounds on resource allocation (not numerically provided in the prompt),
% so we use safe explicit bounds implied by total_resource_max.
int: X1_lb = 0; int: X1_ub = total_resource_max;
int: X2_lb = 0; int: X2_ub = total_resource_max;
int: X3_lb = 0; int: X3_ub = total_resource_max;

% Variables
var X1_lb..X1_ub: X1;
var X2_lb..X2_ub: X2;
var X3_lb..X3_ub: X3;

var 0..(cost1*total_resource_max + cost2*total_resource_max + cost3*total_resource_max): total_cost;

% Constraints
constraint X1 + X2 + X3 <= total_resource_max;

constraint eff1 * X1 + eff2 * X2 >= eff_min;

constraint diff3_coeff * X3 - diff1_coeff * X1 <= diff_rhs;

constraint total_cost = cost1 * X1 + cost2 * X2 + cost3 * X3;

% Objective
solve minimize total_cost;