% Parameters
int: r_res = 100;
int: r_com = 200;
int: r_ind = 300;

int: budget = 50;
int: diversify_min = 30;
int: com_ind_max = 20;

% Variables
var 0..budget: x; % residential
var 0..budget: y; % commercial
var 0..budget: z; % industrial

var 0..(r_res*budget + r_com*budget + r_ind*budget): total_return;

% Constraints
constraint x + y + z <= budget;
constraint 2*x + y >= diversify_min;
constraint y + z <= com_ind_max;

constraint total_return = r_res*x + r_com*y + r_ind*z;

% Objective
solve minimize total_return;