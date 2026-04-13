% Parameters
int: w_train = 5;
int: w_equip = 3;
int: w_nutri = 2;

int: max_train_equip = 50;
int: min_train_nutri = 30;
int: max_diff_equip_nutri = 10;

% Variables
var 0..50: train;
var 0..50: equip;
var 0..50: nutri;

var 0..(w_train*50 + w_equip*50 + w_nutri*50): total_cost;

% Constraints
constraint train + equip <= max_train_equip;
constraint train + nutri >= min_train_nutri;
constraint abs(equip - nutri) <= max_diff_equip_nutri;

constraint total_cost = w_train*train + w_equip*equip + w_nutri*nutri;

% Objective
solve minimize total_cost;