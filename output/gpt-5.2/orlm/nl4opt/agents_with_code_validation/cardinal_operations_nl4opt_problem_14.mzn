% Parameters
int: scooter_capacity = 2;          % people per scooter
int: rickshaw_capacity = 3;         % people per rickshaw
int: min_visitors = 300;            % minimum visitors to transport
float: max_rickshaw_fraction = 0.4; % at most this fraction of vehicles can be rickshaws (given)

% Variables
% Upper bounds are safe over-approximations: enough vehicles to reach min_visitors using only that type.
var 0..ceil(min_visitors / scooter_capacity): scooters;    % number of scooters used (objective)
var 0..ceil(min_visitors / rickshaw_capacity): rickshaws;  % number of rickshaws used

% Constraints
% Minimum transport capacity: total people carried by scooters and rickshaws
constraint
  scooter_capacity * scooters + rickshaw_capacity * rickshaws >= min_visitors;

% Pollution limit: rickshaws are at most 40% of all vehicles
% rickshaws <= max_rickshaw_fraction * (scooters + rickshaws)
% With max_rickshaw_fraction = 0.4, this is equivalent to: 3*rickshaws <= 2*scooters (integer-safe form).
constraint
  3 * rickshaws <= 2 * scooters;

% Objective
solve minimize scooters;