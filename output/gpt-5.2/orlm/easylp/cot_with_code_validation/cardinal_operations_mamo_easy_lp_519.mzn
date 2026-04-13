% Parameters
int: total_cap = 500;

int: min_x = 100;
int: min_y = 150;
int: min_z = 200;

int: lb_x = 0;   int: ub_x = 300;
int: lb_y = 0;   int: ub_y = 400;
int: lb_z = 0;   int: ub_z = 600;

int: cost_x = 5;
int: cost_y = 10;
int: cost_z = 15;

% Variables
var lb_x..ub_x: x;
var lb_y..ub_y: y;
var lb_z..ub_z: z;

var 0..(cost_x*ub_x + cost_y*ub_y + cost_z*ub_z): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

constraint x + y + z <= total_cap;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;