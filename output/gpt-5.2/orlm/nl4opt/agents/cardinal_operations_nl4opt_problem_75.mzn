% Parameters
int: van_capacity = 50;             % pairs of shoes a van can carry
int: truck_capacity = 100;          % pairs of shoes a truck can carry
int: min_total_pairs = 2000;        % minimum pairs of shoes to supply

% Useful derived bounds (for bounded variable declarations)
int: max_vans = (min_total_pairs div van_capacity) + 1;       % safe upper bound
int: max_trucks = (min_total_pairs div truck_capacity) + 1;   % safe upper bound

% Variables
var 0..max_vans: vans;              % number of vans used (objective: minimize)
var 0..max_trucks: trucks;          % number of trucks used

% Constraints
% Meet minimum required supply of shoes
constraint van_capacity * vans + truck_capacity * trucks >= min_total_pairs;

% Fleet composition rule: trucks cannot exceed vans
constraint trucks <= vans;

% Objective
solve minimize vans;