% Parameters
int: max_train_equip = 50;
int: min_train_nutri = 30;
int: max_equip_minus_nutri = 10;

int: w_train = 5;
int: w_equip = 3;
int: w_nutri = 2;

% Variables
var 0..max_train_equip: train;     % training hours
var 0..max_train_equip: equip;     % equipment cost units
var 0..max_train_equip: nutri;     % nutrition cost units

var 0..(w_train*max_train_equip + w_equip*max_train_equip + w_nutri*max_train_equip): total_cost;

% Constraints
constraint train + equip <= max_train_equip;
constraint train + nutri >= min_train_nutri;

constraint equip - nutri <= max_equip_minus_nutri;
constraint nutri - equip <= max_equip_minus_nutri;

constraint total_cost = w_train*train + w_equip*equip + w_nutri*nutri;

% Objective
solve minimize total_cost;