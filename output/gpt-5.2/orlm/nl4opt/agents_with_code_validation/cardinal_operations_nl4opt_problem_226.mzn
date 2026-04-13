% Parameters
int: calories_salmon = 300;      % calories per bowl of salmon
int: protein_salmon  = 15;       % grams protein per bowl of salmon
int: sodium_salmon   = 80;       % mg sodium per bowl of salmon

int: calories_eggs   = 200;      % calories per bowl of eggs
int: protein_eggs    = 8;        % grams protein per bowl of eggs
int: sodium_eggs     = 20;       % mg sodium per bowl of eggs

int: min_calories = 2000;        % minimum required calories
int: min_protein  = 90;          % minimum required protein (grams)

int: egg_ratio_num = 2;          % eggs <= 40% of total meals
int: egg_ratio_den = 5;          % 0.4 = 2/5 (kept for clarity)

% Variable upper bounds derived from minimum requirements to keep search bounded
int: max_eggs   = min_calories div calories_eggs;    % 2000/200 = 10
int: max_salmon = min_calories div calories_salmon;  % 2000/300 = 6


% Variables
var 0..max_salmon: bowls_salmon; % number of salmon bowls (meals)
var 0..max_eggs:   bowls_eggs;   % number of egg bowls (meals)

var 0..(sodium_salmon*max_salmon + sodium_eggs*max_eggs): total_sodium; % total sodium (mg)


% Constraints

% --- Nutrition minimum requirements ---
constraint
  calories_salmon * bowls_salmon + calories_eggs * bowls_eggs >= min_calories;

constraint
  protein_salmon * bowls_salmon + protein_eggs * bowls_eggs >= min_protein;

% --- Eggs proportion limit (at most 40% of total meals) ---
constraint
  % eggs <= 0.4 * (eggs + salmon)
  % <=> 5*eggs <= 2*(eggs+salmon)
  % <=> (5-2)*eggs <= 2*salmon
  (egg_ratio_den - egg_ratio_num) * bowls_eggs <= egg_ratio_num * bowls_salmon;

% --- Total sodium definition ---
constraint
  total_sodium = sodium_salmon * bowls_salmon + sodium_eggs * bowls_eggs;


% Objective
solve minimize total_sodium;