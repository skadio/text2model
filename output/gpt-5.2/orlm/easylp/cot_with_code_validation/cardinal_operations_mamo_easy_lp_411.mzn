% Parameters
int: cost_x = 30000;
int: cost_y = 40000;
int: cost_z = 50000;
int: cost_w = 60000;

int: x_lb = 0;  int: x_ub = 15;
int: y_lb = 0;  int: y_ub = 20;
int: z_lb = 0;  int: z_ub = 25;
int: w_lb = 0;  int: w_ub = 30;

% Variables
var x_lb..x_ub: x; % residential
var y_lb..y_ub: y; % commercial
var z_lb..z_ub: z; % industrial
var w_lb..w_ub: w; % mixed-use

var int: total_cost;

% Constraints
constraint x + y <= 20;
constraint z + w <= 30;
constraint x + z >= 10;
constraint y + w >= 15;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z + cost_w * w;

% Objective
solve minimize total_cost;