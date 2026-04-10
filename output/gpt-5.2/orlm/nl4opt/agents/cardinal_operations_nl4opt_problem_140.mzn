% Parameters
% Composition (kg of ingredient per kg of product)
float: reg_in_regular_mix = 0.8;
float: sour_in_regular_mix = 0.2;
float: reg_in_sour_surprise = 0.1;
float: sour_in_sour_surprise = 0.9;

% Profit per kg of each product
int: profit_regular_mix = 3;
int: profit_sour_surprise = 5;

% Available inventory (kg)
int: available_regular_candy = 80;
int: available_sour_candy = 60;

% Variables
% Decision variables: kilograms produced of each mix (nonnegative)
var float: kg_regular_mix;
var float: kg_sour_surprise_mix;

% Constraints
% Nonnegativity bounds (explicit constraints, since float vars are unbounded by default)
constraint kg_regular_mix >= 0.0;
constraint kg_sour_surprise_mix >= 0.0;

% Inventory constraints: regular candy usage cannot exceed availability
constraint
  reg_in_regular_mix * kg_regular_mix
+ reg_in_sour_surprise * kg_sour_surprise_mix
<= int2float(available_regular_candy);

% Inventory constraints: sour candy usage cannot exceed availability
constraint
  sour_in_regular_mix * kg_regular_mix
+ sour_in_sour_surprise * kg_sour_surprise_mix
<= int2float(available_sour_candy);

% Objective
solve maximize
  profit_regular_mix * kg_regular_mix
+ profit_sour_surprise * kg_sour_surprise_mix;