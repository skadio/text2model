% Parameters (with values embedded)
int: return_x = 100;
int: return_y = 200;
int: return_z = 300;

int: budget = 50;
int: min_diversification = 30;
int: max_yz = 20;

% Variables
var 0..50: x;  % residential units
var 0..50: y;  % commercial units
var 0..50: z;  % industrial units

var 0..(return_x*budget + return_y*budget + return_z*budget): total_return;

% Constraints
constraint x + y + z <= budget;
constraint 2 * x + y >= min_diversification;
constraint y + z <= max_yz;

constraint total_return = return_x * x + return_y * y + return_z * z;

% Objective
solve minimize total_return;