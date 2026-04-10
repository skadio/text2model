% Parameters
int: total_hectares = 140;                  % Total available land (hectares)

int: min_tomatoes = 20;                     % Minimum hectares of tomatoes required
int: min_potatoes = 30;                     % Minimum hectares of potatoes required

int: profit_per_hectare_tomatoes = 350;     % Profit per hectare of tomatoes ($/ha)
int: profit_per_hectare_potatoes = 600;     % Profit per hectare of potatoes ($/ha)

int: max_total_profit =
  total_hectares * max(profit_per_hectare_tomatoes, profit_per_hectare_potatoes);
% Safe upper bound for the objective

% Variables
var min_tomatoes..total_hectares: hectares_tomatoes;   % Hectares planted with tomatoes
var min_potatoes..total_hectares: hectares_potatoes;   % Hectares planted with potatoes

var 0..max_total_profit: total_profit;                 % Total profit ($)

% Constraints
% Land availability: total hectares planted cannot exceed available land
constraint
  hectares_tomatoes + hectares_potatoes <= total_hectares;

% Preference and agronomic ratio limits:
% - Prefer more tomatoes than potatoes
% - Can grow at most twice as many tomatoes as potatoes
constraint
  hectares_tomatoes > hectares_potatoes;

constraint
  hectares_tomatoes <= 2 * hectares_potatoes;

% Profit definition: link total_profit to planted areas and per-hectare profits
constraint
  total_profit =
    profit_per_hectare_tomatoes * hectares_tomatoes +
    profit_per_hectare_potatoes * hectares_potatoes;

% Objective
solve maximize total_profit;