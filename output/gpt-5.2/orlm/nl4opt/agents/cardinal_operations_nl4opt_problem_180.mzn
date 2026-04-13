% Parameters
int: vitC_orange = 5;        % Vitamin C units per orange
int: vitA_orange = 3;        % Vitamin A units per orange
int: sugar_orange = 5;       % Sugar grams per orange

int: vitC_grapefruit = 7;    % Vitamin C units per grapefruit
int: vitA_grapefruit = 5;    % Vitamin A units per grapefruit
int: sugar_grapefruit = 6;   % Sugar grams per grapefruit

int: req_vitC = 80;          % Minimum required Vitamin C units
int: req_vitA = 70;          % Minimum required Vitamin A units

int: pref_ratio = 2;         % Oranges must be at least this multiple of grapefruit

% Safe upper bounds derived from requirements (to bound decision variables)
int: max_oranges = max(ceil(req_vitC / vitC_orange), ceil(req_vitA / vitA_orange));
int: max_grapefruit = max(ceil(req_vitC / vitC_grapefruit), ceil(req_vitA / vitA_grapefruit));

% Variables
var 0..max_oranges: oranges;                 % Number of oranges to eat
var 0..max_grapefruit: grapefruit;           % Number of grapefruits to eat
var 0..(sugar_orange*max_oranges + sugar_grapefruit*max_grapefruit): total_sugar; % Total sugar intake

% Constraints

% Link total sugar variable to chosen quantities
constraint
  total_sugar =
    sugar_orange * oranges +
    sugar_grapefruit * grapefruit;

% Meet minimum Vitamin C requirement
constraint
  vitC_orange * oranges +
  vitC_grapefruit * grapefruit >= req_vitC;

% Meet minimum Vitamin A requirement
constraint
  vitA_orange * oranges +
  vitA_grapefruit * grapefruit >= req_vitA;

% Preference constraint: at least pref_ratio times as many oranges as grapefruit
constraint
  oranges >= pref_ratio * grapefruit;

% Objective
solve minimize total_sugar;