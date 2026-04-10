% Parameters
int: total_hectares = 140;                 % Total available land (hectares)

int: min_tomatoes = 20;                    % Minimum hectares of tomatoes
int: min_potatoes = 30;                    % Minimum hectares of potatoes

int: profit_tomatoes = 350;                % Profit per hectare of tomatoes ($/ha)
int: profit_potatoes = 600;                % Profit per hectare of potatoes ($/ha)

int: tomato_to_potato_max_ratio = 2;       % Tomatoes can be at most 2x potatoes


% Variables
var min_tomatoes..total_hectares: hectares_tomatoes;  % Hectares planted with tomatoes
var min_potatoes..total_hectares: hectares_potatoes;  % Hectares planted with potatoes

% Total profit upper bound: all land in the higher-profit crop (potatoes) is safe
var 0..(profit_tomatoes * total_hectares + profit_potatoes * total_hectares): total_profit;


% Constraints

% Land availability: total planted hectares cannot exceed available land
constraint
  hectares_tomatoes + hectares_potatoes <= total_hectares;

% Preference: plant more tomatoes than potatoes
constraint
  hectares_tomatoes > hectares_potatoes;

% Agronomic limit: tomatoes can be at most a given multiple of potatoes
constraint
  hectares_tomatoes <= tomato_to_potato_max_ratio * hectares_potatoes;

% Define total profit from planted hectares (linear profit function)
constraint
  total_profit =
    profit_tomatoes * hectares_tomatoes +
    profit_potatoes * hectares_potatoes;


% Objective
solve maximize total_profit;

output [
  "hectares_tomatoes=", show(hectares_tomatoes), "\n",
  "hectares_potatoes=", show(hectares_potatoes), "\n",
  "total_profit=$", show(total_profit), "\n"
];