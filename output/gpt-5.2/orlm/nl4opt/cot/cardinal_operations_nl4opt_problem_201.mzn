% Parameters (with values embedded)
int: attract_throw = 15;
int: attract_climb = 8;
int: cost_throw = 2;
int: cost_climb = 3;
int: min_climb = 5;
int: prize_budget = 100;

% Variables
var 0..prize_budget div cost_throw: throwing_games;
var min_climb..prize_budget div cost_climb: climbing_games;

% Constraints
constraint throwing_games >= 2 * climbing_games;
constraint cost_throw * throwing_games + cost_climb * climbing_games <= prize_budget;

% Objective
var int: total_customers = attract_throw * throwing_games + attract_climb * climbing_games;
solve maximize total_customers;