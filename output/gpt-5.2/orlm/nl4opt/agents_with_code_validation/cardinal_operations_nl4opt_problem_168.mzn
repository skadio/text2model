% Parameters
int: material_per_basketball = 5;        % material units needed per basketball
int: time_per_basketball     = 1;        % labor hours needed per basketball
int: material_per_football   = 3;        % material units needed per football
int: time_per_football       = 2;        % labor hours needed per football

int: total_material_available = 1500;    % total material units available
int: total_time_available     = 750;     % total labor hours available

int: min_footballs = 50;                % minimum footballs to produce
int: basketballs_to_footballs_ratio = 3; % basketballs >= 3 * footballs

% Variables
var 0..(total_material_available div material_per_basketball): basketballs; % number of basketballs produced
var 0..(total_material_available div material_per_football):   footballs;   % number of footballs produced

% Constraints
% Material capacity constraint (total material used cannot exceed availability)
constraint
  material_per_basketball * basketballs + material_per_football * footballs
  <= total_material_available;

% Labor time capacity constraint (total hours used cannot exceed availability)
constraint
  time_per_basketball * basketballs + time_per_football * footballs
  <= total_time_available;

% Minimum football production requirement
constraint
  footballs >= min_footballs;

% Demand/marketing constraint: at least a given ratio of basketballs to footballs
constraint
  basketballs >= basketballs_to_footballs_ratio * footballs;

% Objective
solve maximize basketballs + footballs;