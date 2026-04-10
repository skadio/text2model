% Parameters
int: cost_solar = 7;
int: cost_wind  = 5;

int: a1_solar = 2;
int: a1_wind  = 3;
int: rhs1_min = 10;

int: a2_solar = 4;
int: a2_wind  = 1;
int: rhs2_max = 15;

% Variables
var 0..rhs2_max: solar;
var 0..rhs2_max: wind;

var 0..(cost_solar*rhs2_max + cost_wind*rhs2_max): total_cost;

% Constraints
constraint a1_solar * solar + a1_wind * wind >= rhs1_min;
constraint a2_solar * solar + a2_wind * wind <= rhs2_max;

constraint total_cost = cost_solar * solar + cost_wind * wind;

% Objective
solve minimize total_cost;