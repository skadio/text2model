% Parameters
int: cost_X = 100;
int: cost_Y = 200;

int: total_funds_max = 50;

int: x_min = 0;
int: x_max = 30;
int: y_min = 0;
int: y_max = 20;

int: eff_x_coeff = 3;
int: eff_y_coeff = -1;
int: eff_min = 10;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var 0..(cost_X * x_max + cost_Y * y_max): total_cost;

% Constraints
constraint X + Y <= total_funds_max;

constraint eff_x_coeff * X + eff_y_coeff * Y >= eff_min;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;