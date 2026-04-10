% Parameters
int: return_x = 100;
int: return_y = 200;
int: return_z = 300;

int: max_total_invest = 50;
int: min_2x_plus_y = 30;
int: max_y_plus_z = 20;

int: lb_x = 0; int: ub_x = max_total_invest;
int: lb_y = 0; int: ub_y = max_total_invest;
int: lb_z = 0; int: ub_z = max_total_invest;

% Variables
var lb_x..ub_x: x;
var lb_y..ub_y: y;
var lb_z..ub_z: z;

var 0..(return_x*ub_x + return_y*ub_y + return_z*ub_z): total_return;

% Constraints
constraint x + y + z <= max_total_invest;
constraint 2*x + y >= min_2x_plus_y;
constraint y + z <= max_y_plus_z;

constraint total_return = return_x*x + return_y*y + return_z*z;

% Objective
solve minimize total_return;