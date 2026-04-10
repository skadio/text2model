% Parameters
int: van_capacity = 6;              % kids per van
int: van_pollution = 7;             % pollution units per van
int: minibus_capacity = 10;         % kids per minibus
int: minibus_pollution = 10;        % pollution units per minibus

int: min_kids = 150;                % at least this many kids must be transported
int: max_minibuses = 10;            % at most this many minibuses can be used

% A safe upper bound for vans: enough to carry all kids with only vans
int: max_vans = min_kids;           % safe bound (here: 150)

% Variables
var 0..max_vans: vans;              % number of vans used
var 0..max_minibuses: minibuses;    % number of minibuses used
var 0..(van_pollution*max_vans + minibus_pollution*max_minibuses): total_pollution; % total pollution

% Constraints
% Capacity constraint: transport at least the required number of kids
constraint
  van_capacity * vans + minibus_capacity * minibuses >= min_kids;

% Fleet composition constraint: number of vans must exceed number of minibuses
constraint
  vans > minibuses;

% Pollution accounting constraint: define total pollution produced
constraint
  total_pollution = van_pollution * vans + minibus_pollution * minibuses;

% Objective
solve minimize total_pollution;