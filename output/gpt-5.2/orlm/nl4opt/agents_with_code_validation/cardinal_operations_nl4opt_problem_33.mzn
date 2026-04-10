% Parameters
int: total_land_acres = 500;              % Total available land in acres
int: total_watering_minutes = 40000;      % Total available watering time (minutes)
int: total_pesticide_budget = 34000;      % Total available pesticide budget ($)

int: water_per_acre_turnips = 50;         % Watering minutes required per acre of turnips
int: pesticide_per_acre_turnips = 80;     % Pesticide cost per acre of turnips ($)
int: revenue_per_acre_turnips = 300;      % Revenue per acre of turnips ($)

int: water_per_acre_pumpkins = 90;        % Watering minutes required per acre of pumpkins
int: pesticide_per_acre_pumpkins = 50;    % Pesticide cost per acre of pumpkins ($)
int: revenue_per_acre_pumpkins = 450;     % Revenue per acre of pumpkins ($)

% Variables
var 0..total_land_acres: acres_turnips;   % Acres planted with turnips
var 0..total_land_acres: acres_pumpkins;  % Acres planted with pumpkins

% Total revenue upper bound assumes (conservatively) all land could be planted with either crop
var 0..(revenue_per_acre_turnips * total_land_acres
      + revenue_per_acre_pumpkins * total_land_acres): total_revenue;

% Constraints
% Land availability
constraint acres_turnips + acres_pumpkins <= total_land_acres;

% Watering time availability
constraint
  water_per_acre_turnips * acres_turnips
+ water_per_acre_pumpkins * acres_pumpkins
<= total_watering_minutes;

% Pesticide budget availability
constraint
  pesticide_per_acre_turnips * acres_turnips
+ pesticide_per_acre_pumpkins * acres_pumpkins
<= total_pesticide_budget;

% Revenue definition
constraint
  total_revenue =
    revenue_per_acre_turnips * acres_turnips
  + revenue_per_acre_pumpkins * acres_pumpkins;

% Objective
solve maximize total_revenue;