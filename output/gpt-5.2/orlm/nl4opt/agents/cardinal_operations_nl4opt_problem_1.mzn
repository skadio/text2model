% Parameters
int: total_ingredients = 1000;              % Total medicinal ingredient units available

int: ing_per_large = 3;                     % Ingredient units needed per large pill
int: filler_per_large = 2;                  % Filler units needed per large pill

int: ing_per_small = 2;                     % Ingredient units needed per small pill
int: filler_per_small = 1;                  % Filler units needed per small pill

int: min_large_pills = 100;                 % Must produce at least this many large pills

int: small_share_num = 60;                  % At least 60% small: use 60/100 to keep linear
int: small_share_den = 100;

% Upper bounds derived from ingredient limit
int: max_large_by_ing = total_ingredients div ing_per_large;
int: max_small_by_ing = total_ingredients div ing_per_small;

% Variables
var 0..max_large_by_ing: num_large;         % Number of large pills to make
var 0..max_small_by_ing: num_small;         % Number of small pills to make

var 0..(filler_per_large*max_large_by_ing + filler_per_small*max_small_by_ing): total_filler;
                                            % Total filler used (objective-related variable)

% Constraints

% Ingredient availability: total medicinal ingredients used cannot exceed supply
constraint
  ing_per_large * num_large + ing_per_small * num_small <= total_ingredients;

% Minimum production requirement for large pills
constraint
  num_large >= min_large_pills;

% Popularity requirement: at least 60% of all pills must be small
% Enforced linearly as: num_small / (num_large + num_small) >= 60/100
constraint
  small_share_den * num_small >= small_share_num * (num_large + num_small);

% Define total filler used based on production quantities
constraint
  total_filler = filler_per_large * num_large + filler_per_small * num_small;

% Objective
solve minimize total_filler;