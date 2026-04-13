% Parameters
int: total_cap = 100;

int: min_2x_plus_y = 30;   % 2*X + Y >= 30
int: min_x_plus_z = 40;    % X + Z >= 40

int: cost_x = 1000;
int: cost_y = 2000;
int: cost_z = 3000;

int: x_lb = 0;  int: x_ub = 50;
int: y_lb = 0;  int: y_ub = 60;
int: z_lb = 0;  int: z_ub = 70;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;
var z_lb..z_ub: z;

var 0..(cost_x*x_ub + cost_y*y_ub + cost_z*z_ub): total_cost;

% Constraints
constraint x + y + z <= total_cap;
constraint 2*x + y >= min_2x_plus_y;
constraint x + z >= min_x_plus_z;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;