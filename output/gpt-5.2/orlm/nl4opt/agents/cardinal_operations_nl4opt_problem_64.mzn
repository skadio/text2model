% Parameters
int: old_van_capacity = 100;        % bottles per old van
int: new_van_capacity = 80;         % bottles per new van
int: old_van_pollution = 50;        % pollution units per old van
int: new_van_pollution = 30;        % pollution units per new van
int: min_bottles_required = 5000;   % minimum bottles to deliver
int: max_new_vans = 30;             % maximum number of new vans allowed

% Variables
% Upper bound for old vans: in the worst case, satisfy demand using only old vans
var 0..ceil(min_bottles_required / old_van_capacity): num_old_vans;  % number of old vans used
var 0..max_new_vans: num_new_vans;                                   % number of new vans used

% Upper bound for total pollution based on variable bounds
var 0..(old_van_pollution * ceil(min_bottles_required / old_van_capacity)
        + new_van_pollution * max_new_vans): total_pollution;         % total pollution produced

% Constraints
% Meet minimum delivery requirement (total bottles shipped must be at least required)
constraint
  old_van_capacity * num_old_vans + new_van_capacity * num_new_vans
  >= min_bottles_required;

% Define total pollution as the sum from old and new vans
constraint
  total_pollution
  = old_van_pollution * num_old_vans + new_van_pollution * num_new_vans;

% Objective
solve minimize total_pollution;