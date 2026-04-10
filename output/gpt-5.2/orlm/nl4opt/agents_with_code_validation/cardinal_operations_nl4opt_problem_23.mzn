% Parameters
int: van_capacity = 6;              % kids per van
int: van_pollution = 7;             % pollution units per van
int: minibus_capacity = 10;         % kids per minibus
int: minibus_pollution = 10;        % pollution units per minibus
int: min_kids = 150;                % at least this many kids must be transported
int: max_minibuses = 10;            % at most this many minibuses can be used

% Variables
var 0..max_minibuses: minibuses;    % number of minibuses used
var 0..min_kids: vans;              % number of vans used (safe upper bound)

var 0..(van_pollution * min_kids + minibus_pollution * max_minibuses): total_pollution;
                                    % total pollution (bounded for linear expressions)

% Constraints
% Capacity constraint: transport at least the required number of kids
constraint
  van_capacity * vans + minibus_capacity * minibuses >= min_kids;

% Minibus availability constraint: already enforced by variable domain (0..max_minibuses)
constraint
  minibuses <= max_minibuses;

% Fleet composition constraint: vans must exceed minibuses
constraint
  vans > minibuses;

% Total pollution definition: link decision variables to total pollution
constraint
  total_pollution = van_pollution * vans + minibus_pollution * minibuses;

% Objective
solve minimize total_pollution;