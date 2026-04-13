% Parameters
int: total_alloc_cap = 100;
int: yz_alloc_cap = 70;

int: cost_x = 3;
int: cost_y = 2;
int: cost_z = 5;

int: x_lb = 0;
int: x_ub = 50;

int: y_lb = 0;
int: y_ub = 30;

int: z_lb = 0;
int: z_ub = total_alloc_cap; % implied by total allocation cap

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var z_lb..z_ub: Z;

var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Constraints
constraint X + Y + Z <= total_alloc_cap;
constraint X >= 2 * Y + 10;
constraint Y + Z <= yz_alloc_cap;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;