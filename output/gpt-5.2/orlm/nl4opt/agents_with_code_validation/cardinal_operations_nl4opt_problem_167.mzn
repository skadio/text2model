% Parameters
% Nutritional requirements (minimums)
int: min_calories = 2200;
int: min_protein  = 50;   % grams
int: min_carbs    = 70;   % grams

% Item data
float: cost_hamburger = 6.5;
int: calories_hamburger = 800;
int: protein_hamburger  = 19;  % grams
int: carbs_hamburger    = 20;  % grams

float: cost_wrap = 4.0;
int: calories_wrap = 450;
int: protein_wrap  = 12;  % grams
int: carbs_wrap    = 10;  % grams


% Variables
% Number of each item to provide (non-negative integers)
var 0..100: hamburgers;   % upper bound chosen to keep search bounded
var 0..100: wraps;        % upper bound chosen to keep search bounded

% Total cost (bounded for linear objective)
var 0.0..10000.0: total_cost;


% Constraints
% --- Cost aggregation (ensure total_cost matches chosen quantities) ---
constraint total_cost = cost_hamburger * hamburgers + cost_wrap * wraps;

% --- Minimum nutrition requirements (calories, protein, carbs) ---
constraint calories_hamburger * hamburgers + calories_wrap * wraps >= min_calories;
constraint protein_hamburger  * hamburgers + protein_wrap  * wraps >= min_protein;
constraint carbs_hamburger    * hamburgers + carbs_wrap    * wraps >= min_carbs;


% Objective
solve minimize total_cost;