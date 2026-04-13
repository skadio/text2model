% Parameters
int: cost_x = 50;
int: cost_y = 60;
int: cost_z = 70;

int: x_lb = 0;
int: x_ub = 200;
int: y_lb = 0;
int: y_ub = 150;
int: z_lb = 0;
int: z_ub = 300;

int: rhs1 = 500;
int: rhs2 = 800;
int: rhs3 = 100;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;
var z_lb..z_ub: z;

var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Constraints
constraint 2*x + 3*y + z >= rhs1;
constraint x + y + 4*z <= rhs2;
constraint x - y + z >= rhs3;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;