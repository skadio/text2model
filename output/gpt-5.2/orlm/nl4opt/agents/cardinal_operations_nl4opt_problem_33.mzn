% Parameters
int: total_land = 500;                 % Total available acres
int: total_watering = 40000;           % Total available watering minutes
int: total_pesticide_budget = 34000;   % Total available pesticide budget ($)

int: water_turnips = 50;              % Watering minutes required per acre of turnips
int: pesticide_turnips = 80;          % Pesticide cost per acre of turnips ($)
int: revenue_turnips = 300;           % Revenue per acre of turnips ($)

int: water_pumpkins = 90;             % Watering minutes required per acre of pumpkins
int: pesticide_pumpkins = 50;         % Pesticide cost per acre of pumpkins ($)
int: revenue_pumpkins = 450;          % Revenue per acre of pumpkins ($)

% Variables
var 0..total_land: acres_turnips;      % Acres planted with turnips
var 0..total_land: acres_pumpkins;     % Acres planted with pumpkins
var 0..(revenue_turnips*total_land + revenue_pumpkins*total_land): total_revenue; % Total revenue ($)

% Constraints
% Land availability: total planted acres cannot exceed available land
constraint
  acres_turnips + acres_pumpkins <= total_land;

% Watering capacity: total watering minutes used cannot exceed available minutes
constraint
  water_turnips * acres_turnips + water_pumpkins * acres_pumpkins <= total_watering;

% Pesticide budget: total pesticide spending cannot exceed available budget
constraint
  pesticide_turnips * acres_turnips + pesticide_pumpkins * acres_pumpkins <= total_pesticide_budget;

% Revenue definition: link total_revenue to acres planted and per-acre revenues
constraint
  total_revenue = revenue_turnips * acres_turnips + revenue_pumpkins * acres_pumpkins;

% Objective
solve maximize total_revenue;