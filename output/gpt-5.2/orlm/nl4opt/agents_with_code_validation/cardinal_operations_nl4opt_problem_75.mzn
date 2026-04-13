% Parameters
int: van_capacity = 50;            % pairs of shoes a van can carry
int: truck_capacity = 100;         % pairs of shoes a truck can carry
int: min_pairs_required = 2000;    % minimum pairs of shoes to supply

% Upper bounds (sufficient for optimality):
% If only vans are used: 2000 / 50 = 40 vans, so vans need not exceed 40.
int: max_vans = ceil(min_pairs_required / van_capacity);
% If only trucks are used: 2000 / 100 = 20 trucks.
int: max_trucks = ceil(min_pairs_required / truck_capacity);

% Variables
var 0..max_vans: vans;             % number of vans used (to be minimized)
var 0..max_trucks: trucks;         % number of trucks used

% Constraints
% Deliver at least the required number of pairs.
constraint van_capacity * vans + truck_capacity * trucks >= min_pairs_required;

% Trucks cannot exceed vans.
constraint trucks <= vans;

% Objective
solve minimize vans;