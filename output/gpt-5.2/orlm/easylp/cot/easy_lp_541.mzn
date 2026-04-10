% Parameters (with values embedded)
int: cost1 = 500;
int: cost2 = 600;
int: cost3 = 700;

int: total_cap = 1000;

int: min_expr_1 = 200;   % 2*X1 - 0.5*X2 >= 200
int: max_expr_2 = 300;   % 2*X3 - X1 <= 300

% Variables
var 0..total_cap: X1;
var 0..total_cap: X2;
var 0..total_cap: X3;

var 0..(cost1*total_cap + cost2*total_cap + cost3*total_cap): TotalCost;

% Constraints
constraint X1 + X2 + X3 <= total_cap;

% Avoid fractions by multiplying by 2:
% 2*X1 - 0.5*X2 >= 200  <=>  4*X1 - X2 >= 400
constraint 4*X1 - X2 >= 2*min_expr_1;

constraint 2*X3 - X1 <= max_expr_2;

constraint TotalCost = cost1*X1 + cost2*X2 + cost3*X3;

% Objective
solve minimize TotalCost;