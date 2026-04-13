% Parameters
int: regular_hours = 110;
int: max_overtime = 10;

int: rate_m_per_hour = 1000;

int: min_curtain_m = 70000;
int: min_clothing_m = 45000;

float: profit_curtain = 2.5;
float: profit_clothing = 1.5;

% Variables
var 0..(regular_hours + max_overtime): hours_curtain;
var 0..(regular_hours + max_overtime): hours_clothing;

var 0..max_overtime: overtime;

% Constraints
constraint
  hours_curtain + hours_clothing = regular_hours + overtime;

constraint
  hours_curtain * rate_m_per_hour >= min_curtain_m;

constraint
  hours_clothing * rate_m_per_hour >= min_clothing_m;

% Objective
solve minimize overtime;