% Parameters
int: vit_veg = 2;
int: min_veg = 3;
int: cost_veg = 3;

int: vit_fruit = 4;
int: min_fruit = 1;
int: cost_fruit = 5;

int: vit_req = 20;
int: min_req = 30;

% Variables
var 0..100: veg_serv;
var 0..100: fruit_serv;

var 0..1000: total_cost;

% Constraints
constraint vit_veg * veg_serv + vit_fruit * fruit_serv >= vit_req;
constraint min_veg * veg_serv + min_fruit * fruit_serv >= min_req;

constraint total_cost = cost_veg * veg_serv + cost_fruit * fruit_serv;

% Objective
solve minimize total_cost;