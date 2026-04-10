% Parameters
int: scooter_capacity = 2;                 % People per scooter
int: rickshaw_capacity = 3;                % People per rickshaw
int: min_visitors = 300;                   % Minimum number of visitors to transport
float: max_rickshaw_fraction = 0.40;       % At most 40% of vehicles can be rickshaws

% Variables
var 0..min_visitors: scooters;             % Number of scooters used (objective: minimize)
var 0..min_visitors: rickshaws;            % Number of rickshaws used

% Constraints
% -- Visitor transport capacity: total carried must meet or exceed demand
constraint
  scooter_capacity * scooters + rickshaw_capacity * rickshaws >= min_visitors;

% -- Pollution rule: rickshaws are at most a fraction of all vehicles
%    rickshaws / (scooters + rickshaws) <= max_rickshaw_fraction
%    Linearized to avoid division:
constraint
  let { int: scale = 100 } in
    (scale * rickshaws) <=
    (round(max_rickshaw_fraction * scale) * (scooters + rickshaws));

% Objective
solve minimize scooters;