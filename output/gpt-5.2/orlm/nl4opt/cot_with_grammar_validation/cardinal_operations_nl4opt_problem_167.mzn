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
var 0..10: hamburgers;
var 0..10: wraps;
var float: total_cost;

% Constraints
constraint cal_hamburger * hamburgers + cal_wrap * wraps >= min_cal;
constraint prot_hamburger * hamburgers + prot_wrap * wraps >= min_prot;
constraint carb_hamburger * hamburgers + carb_wrap * wraps >= min_carb;

constraint total_cost = cost_hamburger * hamburgers + cost_wrap * wraps;

% Objective
solve minimize total_cost;