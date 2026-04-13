% Parameters
int: attract_throw = 15;
int: attract_climb = 8;
int: cost_throw = 2;
int: cost_climb = 3;

int: budget = 100;
int: min_climb = 5;

% Variables
var 0..(budget div cost_throw): throw_games;
var 0..(budget div cost_climb): climb_games;

var 0..(attract_throw * (budget div cost_throw) + attract_climb * (budget div cost_climb)): total_customers;

% Constraints
constraint cost_throw * throw_games + cost_climb * climb_games <= budget;
constraint throw_games >= 2 * climb_games;
constraint climb_games >= min_climb;

constraint total_customers = attract_throw * throw_games + attract_climb * climb_games;

% Objective
solve maximize total_customers;