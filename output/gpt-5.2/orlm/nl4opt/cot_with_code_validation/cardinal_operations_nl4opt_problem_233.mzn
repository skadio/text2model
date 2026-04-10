% Parameters
int: min_calcium = 15;
int: min_vitamins = 20;
int: min_protein = 20;

int: cost_regular = 20;
int: cost_premium = 35;

int: cal_regular = 4;
int: vit_regular = 7;
int: pro_regular = 10;

int: cal_premium = 12;
int: vit_premium = 10;
int: pro_premium = 16;

% Variables
var 0..10: bags_regular;
var 0..10: bags_premium;

var 0..1000: total_cost;

% Constraints
constraint cal_regular * bags_regular + cal_premium * bags_premium >= min_calcium;
constraint vit_regular * bags_regular + vit_premium * bags_premium >= min_vitamins;
constraint pro_regular * bags_regular + pro_premium * bags_premium >= min_protein;

constraint total_cost = cost_regular * bags_regular + cost_premium * bags_premium;

% Objective
solve minimize total_cost;