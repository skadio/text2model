% Parameters
% Cost coefficients for each product category
int: c1 = 2;   % cost per unit of x1 (clothing)
int: c2 = 3;   % cost per unit of x2 (electronics)
int: c3 = 4;   % cost per unit of x3 (groceries)
int: c4 = 5;   % cost per unit of x4 (home appliances)

% Constraint bounds
int: ub_x1_x2 = 100;     % x1 + x2 <= 100
int: lb_2x1_x3 = 50;     % 2*x1 + x3 >= 50
int: ub_x2_3x4 = 20;     % x2 - 3*x4 <= 20
int: lb_x4_halfx1 = 10;  % x4 - 0.5*x1 >= 10

% Derived integer form of the fractional constraint:
% x4 - 0.5*x1 >= 10  <=>  2*x4 - x1 >= 20
int: lb_2x4_x1 = 2 * lb_x4_halfx1;

% Variable bounds (nonnegativity; x1,x2 also bounded by x1+x2 <= 100)
int: x1_lb = 0;
int: x2_lb = 0;
int: x3_lb = 0;
int: x4_lb = 0;

int: x1_ub = ub_x1_x2;
int: x2_ub = ub_x1_x2;

% No explicit finite upper bounds for x3,x4 are given; use reasonable big-M bounds
int: x3_ub = 1000;
int: x4_ub = 1000;


% Variables
var x1_lb..x1_ub: x1;   % allocation to clothing
var x2_lb..x2_ub: x2;   % allocation to electronics
var x3_lb..x3_ub: x3;   % allocation to groceries
var x4_lb..x4_ub: x4;   % allocation to home appliances

var int: total_cost;    % total cost (objective value)


% Constraints
% Link objective variable to decision variables
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Budget / capacity limits
constraint x1 + x2 <= ub_x1_x2;

% Minimum allocation / coverage constraint
constraint 2 * x1 + x3 >= lb_2x1_x3;

% Electronics vs home appliances relation
constraint x2 - 3 * x4 <= ub_x2_3x4;

% Fractional constraint in integer form (avoid coercion)
constraint 2 * x4 - x1 >= lb_2x4_x1;


% Objective
solve minimize total_cost;