% Parameters
% Nutrient content per pill
int: iron_A = 5;
int: calcium_A = 10;
int: iron_B = 4;
int: calcium_B = 15;

% Minimum daily requirements
int: min_iron = 40;
int: min_calcium = 50;

% Cost per pill
int: cost_A = 2;
int: cost_B = 3;

% Safe upper bounds on pills (derived from meeting minimums with a single supplement)
% Use integer arithmetic for ceilings: ceil(a/b) = (a + b - 1) div b
int: maxA = max( (min_iron + iron_A - 1) div iron_A,
                 (min_calcium + calcium_A - 1) div calcium_A );
int: maxB = max( (min_iron + iron_B - 1) div iron_B,
                 (min_calcium + calcium_B - 1) div calcium_B );

% Variables
var 0..maxA: pills_A; % number of pills of supplement A to buy
var 0..maxB: pills_B; % number of pills of supplement B to buy

var 0..(iron_A*maxA + iron_B*maxB): total_iron;          % total iron units obtained
var 0..(calcium_A*maxA + calcium_B*maxB): total_calcium; % total calcium units obtained
var 0..(cost_A*maxA + cost_B*maxB): total_cost;          % total cost


% Constraints
% --- Link totals to decision variables ---
constraint total_iron = iron_A * pills_A + iron_B * pills_B;
constraint total_calcium = calcium_A * pills_A + calcium_B * pills_B;
constraint total_cost = cost_A * pills_A + cost_B * pills_B;

% --- Minimum daily nutrient requirements ---
constraint total_iron >= min_iron;
constraint total_calcium >= min_calcium;


% Objective
solve minimize total_cost;