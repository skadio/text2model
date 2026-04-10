% Parameters (with values embedded)
int: total_resource = 1000;
int: res_tank = 5;
int: res_aircraft = 3;
int: res_submarine = 2;

int: strength_min = 200;

int: cost_tank = 30;
int: cost_aircraft = 20;
int: cost_submarine = 10;

% Variables
var 0..(total_resource div res_tank): Tanks;
var 0..(total_resource div res_aircraft): Aircrafts;
var 0..(total_resource div res_submarine): Submarines;

var 0..(cost_tank*(total_resource div res_tank)
       + cost_aircraft*(total_resource div res_aircraft)
       + cost_submarine*(total_resource div res_submarine)): TotalCost;

% Constraints
constraint res_tank*Tanks + res_aircraft*Aircrafts + res_submarine*Submarines <= total_resource;

constraint 2*Tanks + 4*Aircrafts + Submarines >= strength_min;

constraint Tanks - (Aircrafts + Submarines) = 50;

constraint TotalCost = cost_tank*Tanks + cost_aircraft*Aircrafts + cost_submarine*Submarines;

% Objective
solve minimize TotalCost;