% Parameters (with values embedded)
int: metal_available = 200;
int: acid_available  = 300;
int: heat_max        = 50;

int: metal_per_cheap = 3;
int: acid_per_cheap  = 5;
int: foam_per_cheap  = 8;
int: heat_per_cheap  = 2;

int: metal_per_exp   = 5;
int: acid_per_exp    = 8;
int: foam_per_exp    = 10;
int: heat_per_exp    = 3;

% Variables
var 0..floor(metal_available div metal_per_cheap): cheap_boxes;
var 0..floor(metal_available div metal_per_exp):  expensive_boxes;

var 0..(foam_per_cheap*floor(metal_available div metal_per_cheap) + foam_per_exp*floor(metal_available div metal_per_exp)): total_foam;

% Constraints
constraint metal_per_cheap * cheap_boxes + metal_per_exp * expensive_boxes <= metal_available;
constraint acid_per_cheap  * cheap_boxes + acid_per_exp  * expensive_boxes <= acid_available;
constraint heat_per_cheap  * cheap_boxes + heat_per_exp  * expensive_boxes <= heat_max;

constraint total_foam = foam_per_cheap * cheap_boxes + foam_per_exp * expensive_boxes;

% Objective
solve maximize total_foam;