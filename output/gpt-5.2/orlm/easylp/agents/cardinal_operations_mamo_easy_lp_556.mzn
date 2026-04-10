% Parameters
int: fatigue_strength = 2;      % fatigue per unit for strength conditioning (x1)
int: fatigue_skill    = 3;      % fatigue per unit for skill development (x2)
int: fatigue_strategy = 5;      % fatigue per unit for strategy & tactics (x3)

int: max_strength_plus_skill = 10;   % x1 + x2 <= 10
int: min_training_req = 20;          % 4*x1 + 5*x3 >= 20
int: max_diff_strategy_skill = 5;    % x3 - x2 <= 5

% Variables
var 0..100: x1;   % whole-number effort units for strength conditioning
var 0..100: x2;   % whole-number effort units for skill development
var 0..100: x3;   % whole-number effort units for strategy & tactics

% Constraints
% Time limitation: combined strength conditioning and skill development effort cannot exceed limit
constraint x1 + x2 <= max_strength_plus_skill;

% Minimum training requirement: weighted combination of strength and strategy must meet threshold
constraint 4 * x1 + 5 * x3 >= min_training_req;

% Balance constraint: strategy effort must not exceed skill effort by more than the allowed difference
constraint x3 - x2 <= max_diff_strategy_skill;

% Proportionality constraint: strategy effort must be at least half of strength effort
% Use multiplication to keep integer arithmetic (avoid division/coercion issues)
constraint 2 * x3 >= x1;

% Objective
solve minimize fatigue_strength * x1 + fatigue_skill * x2 + fatigue_strategy * x3;