% Parameters
float: cost_hamburger = 6.5;
float: cost_wrap = 4.0;

int: cal_hamburger = 800;
int: prot_hamburger = 19;
int: carb_hamburger = 20;

int: cal_wrap = 450;
int: prot_wrap = 12;
int: carb_wrap = 10;

int: min_cal = 2200;
int: min_prot = 50;
int: min_carb = 70;

% Variables
var 0..10: x_hamburger;
var 0..20: x_wrap;

var float: total_cost;

% Constraints
constraint
  cal_hamburger * x_hamburger + cal_wrap * x_wrap >= min_cal;

constraint
  prot_hamburger * x_hamburger + prot_wrap * x_wrap >= min_prot;

constraint
  carb_hamburger * x_hamburger + carb_wrap * x_wrap >= min_carb;

constraint
  total_cost = cost_hamburger * int2float(x_hamburger) + cost_wrap * int2float(x_wrap);

% Objective
solve minimize total_cost;