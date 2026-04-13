% Parameters
% Nutrient content per fruit
int: vitC_orange = 5;        % units of vitamin C in one orange
int: vitA_orange = 3;        % units of vitamin A in one orange
int: sugar_orange = 5;       % grams of sugar in one orange

int: vitC_grapefruit = 7;    % units of vitamin C in one grapefruit
int: vitA_grapefruit = 5;    % units of vitamin A in one grapefruit
int: sugar_grapefruit = 6;   % grams of sugar in one grapefruit

% Minimum required intake
int: min_vitC = 80;          % minimum units of vitamin C required
int: min_vitA = 70;          % minimum units of vitamin A required

% Preference constraint (oranges at least pref_ratio times grapefruits)
int: pref_ratio = 2;         % oranges >= pref_ratio * grapefruits

% Safe upper bounds (use integer arithmetic to avoid float coercions)
function int: ceil_div(int: a, int: b) = (a + b - 1) div b;

int: max_oranges =
  max(ceil_div(min_vitC, vitC_orange), ceil_div(min_vitA, vitA_orange));
int: max_grapefruit =
  max(ceil_div(min_vitC, vitC_grapefruit), ceil_div(min_vitA, vitA_grapefruit));

% Variables
var 0..max_oranges: oranges;          % number of oranges to eat
var 0..max_grapefruit: grapefruit;    % number of grapefruits to eat

var 0..(sugar_orange*max_oranges + sugar_grapefruit*max_grapefruit): total_sugar;

% Constraints
% --- Nutrient requirement constraints ---
constraint vitC_orange * oranges + vitC_grapefruit * grapefruit >= min_vitC;
constraint vitA_orange * oranges + vitA_grapefruit * grapefruit >= min_vitA;

% --- Preference constraint ---
constraint oranges >= pref_ratio * grapefruit;

% --- Total sugar definition ---
constraint total_sugar = sugar_orange * oranges + sugar_grapefruit * grapefruit;

% Objective
solve minimize total_sugar;