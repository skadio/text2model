% Parameters
int: total_resource = 1000;
int: res_tank = 5;
int: res_aircraft = 3;
int: res_submarine = 2;

int: strength_min = 200;
int: diff_target = 50;

int: cost_tank = 30;
int: cost_aircraft = 20;
int: cost_submarine = 10;

% Variables
var 0..(total_resource div res_tank): tanks;
var 0..(total_resource div res_aircraft): aircrafts;
var 0..(total_resource div res_submarine): submarines;

var 0..(cost_tank*(total_resource div res_tank)
       + cost_aircraft*(total_resource div res_aircraft)
       + cost_submarine*(total_resource div res_submarine)): total_cost;

% Constraints
constraint res_tank * tanks + res_aircraft * aircrafts + res_submarine * submarines <= total_resource;

constraint 2 * tanks + 4 * aircrafts + submarines >= strength_min;

constraint tanks - aircrafts + submarines = diff_target;

constraint total_cost = cost_tank * tanks + cost_aircraft * aircrafts + cost_submarine * submarines;

% Objective
solve minimize total_cost;