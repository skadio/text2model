% Parameters
int: total_resource = 1000;
int: res_tank = 5;
int: res_aircraft = 3;
int: res_submarine = 2;

int: min_strength = 200;
int: str_tank = 2;
int: str_aircraft = 4;
int: str_submarine = 1;

int: diff_target = 50;

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
constraint res_tank * Tanks + res_aircraft * Aircrafts + res_submarine * Submarines <= total_resource;

constraint str_tank * Tanks + str_aircraft * Aircrafts + str_submarine * Submarines >= min_strength;

constraint Tanks - Aircrafts + Submarines = diff_target;

constraint TotalCost = cost_tank * Tanks + cost_aircraft * Aircrafts + cost_submarine * Submarines;

% Objective
solve minimize TotalCost;