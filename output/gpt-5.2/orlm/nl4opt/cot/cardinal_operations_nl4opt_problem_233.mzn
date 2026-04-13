% Parameters (with values embedded)
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

% Upper bounds chosen safely from requirements (nonnegative integer bags)
int: max_regular = max( max(ceil(min_calcium div 1), ceil(min_vitamins div 1)), ceil(min_protein div 1) );
int: max_premium = max( max(ceil(min_calcium div 1), ceil(min_vitamins div 1)), ceil(min_protein div 1) );

% Variables
var 0..20: x_regular;  % number of regular bags
var 0..20: x_premium;  % number of premium bags

% Constraints
constraint cal_regular * x_regular + cal_premium * x_premium >= min_calcium;
constraint vit_regular * x_regular + vit_premium * x_premium >= min_vitamins;
constraint pro_regular * x_regular + pro_premium * x_premium >= min_protein;

% Objective
solve minimize cost_regular * x_regular + cost_premium * x_premium;