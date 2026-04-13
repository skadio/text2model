% Parameters
int: budget = 80;
int: min_score = 100;

int: score_solar = 3;
int: score_wind  = 2;

int: cost_solar = 10;
int: cost_wind  = 20;

int: max_solar = 50;
int: max_wind  = 40;

% Variables
var 0..max_solar: solar;
var 0..max_wind: wind;
var 0..(cost_solar*max_solar + cost_wind*max_wind): total_cost;

% Constraints
constraint solar + wind <= budget;
constraint score_solar * solar + score_wind * wind >= min_score;
constraint solar >= wind;

constraint total_cost = cost_solar * solar + cost_wind * wind;

% Objective
solve minimize total_cost;