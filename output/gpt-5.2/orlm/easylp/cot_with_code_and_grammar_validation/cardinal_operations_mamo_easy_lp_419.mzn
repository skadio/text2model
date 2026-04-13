% Parameters
int: budget = 80;
int: min_score = 100;

int: solar_score_coeff = 3;
int: wind_score_coeff  = 2;

int: solar_cost = 10;
int: wind_cost  = 20;

int: solar_ub = 50;
int: wind_ub  = 40;

% Variables
var 0..solar_ub: solar;
var 0..wind_ub: wind;
var 0..(solar_cost*solar_ub + wind_cost*wind_ub): total_cost;

% Constraints
constraint solar + wind <= budget;

constraint solar_score_coeff * solar + wind_score_coeff * wind >= min_score;

constraint solar >= wind;

constraint total_cost = solar_cost * solar + wind_cost * wind;

% Objective
solve minimize total_cost;