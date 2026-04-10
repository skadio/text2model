% Parameters
int: train_cost = 5;
int: equip_cost = 3;
int: nutr_cost  = 2;

int: max_train_plus_equip = 50;
int: min_train_plus_nutr  = 30;
int: max_equip_minus_nutr = 10;

% Variables
var 0..max_train_plus_equip: training;
var 0..max_train_plus_equip: equipment;
var 0..max_train_plus_equip: nutrition;

var 0..(train_cost*max_train_plus_equip + equip_cost*max_train_plus_equip + nutr_cost*max_train_plus_equip): total_cost;

% Constraints
constraint training + equipment <= max_train_plus_equip;
constraint training + nutrition >= min_train_plus_nutr;
constraint abs(equipment - nutrition) <= max_equip_minus_nutr;

constraint total_cost = train_cost*training + equip_cost*equipment + nutr_cost*nutrition;

% Objective
solve minimize total_cost;