% Parameters
int: material_per_basketball = 5;      % material units needed per basketball
int: labor_hours_per_basketball = 1;   % labor hours needed per basketball
int: material_per_football = 3;        % material units needed per football
int: labor_hours_per_football = 2;     % labor hours needed per football

int: total_material_available = 1500;   % total material units available
int: total_labor_hours_available = 750; % total labor hours available

int: min_footballs = 50;               % minimum number of footballs desired
int: basketball_to_football_ratio = 3; % at least 3x as many basketballs as footballs

% Derived upper bounds (safe, integer)
int: max_basketballs =
  min(total_material_available div material_per_basketball,
      total_labor_hours_available div labor_hours_per_basketball);
int: max_footballs =
  min(total_material_available div material_per_football,
      total_labor_hours_available div labor_hours_per_football);

% Variables
var 0..max_basketballs: basketballs;   % number of basketballs to produce
var 0..max_footballs: footballs;       % number of footballs to produce

% Constraints
% Resource capacity: total material used cannot exceed available material
constraint
  material_per_basketball * basketballs + material_per_football * footballs
  <= total_material_available;

% Resource capacity: total labor hours used cannot exceed available labor hours
constraint
  labor_hours_per_basketball * basketballs + labor_hours_per_football * footballs
  <= total_labor_hours_available;

% Demand requirement: produce at least the minimum number of footballs
constraint footballs >= min_footballs;

% Sales preference: at least `basketball_to_football_ratio` times as many basketballs as footballs
constraint basketballs >= basketball_to_football_ratio * footballs;

% Objective
solve maximize basketballs + footballs;