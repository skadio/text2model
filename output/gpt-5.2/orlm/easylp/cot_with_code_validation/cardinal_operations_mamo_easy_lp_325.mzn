% Parameters
int: budget = 50;
int: min_diversification = 30;
int: max_yz = 20;

int: r_x = 100;
int: r_y = 200;
int: r_z = 300;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;

var 0..(r_z * budget): total_return;

% Constraints
constraint x + y + z <= budget;

constraint 2 * x + y >= min_diversification;

constraint y + z <= max_yz;

constraint total_return = r_x * x + r_y * y + r_z * z;

% Objective
solve minimize total_return;