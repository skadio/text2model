% Parameters
int: max_total_properties = 1000;            % Upper limit on total number of properties
int: min_weighted_properties = 2000;         % Minimum required value of 3*X + 2*Y
int: max_difference = 300;                   % Maximum allowed absolute difference |X - Y|

int: cost_residential_k = 200;               % Cost per residential property (thousand dollars)
int: cost_commercial_k = 150;                % Cost per commercial property (thousand dollars)

% Variables
var 0..max_total_properties: X;              % Number of residential properties (integer)
var 0..max_total_properties: Y;              % Number of commercial properties (integer)

var 0..(cost_residential_k*max_total_properties + cost_commercial_k*max_total_properties): total_cost_k;
                                             % Total investment cost (thousand dollars)

% Constraints
% Total properties limit (financial constraint)
constraint
  X + Y <= max_total_properties;

% Diversification constraint: weighted total must meet minimum
constraint
  3 * X + 2 * Y >= min_weighted_properties;

% Balance constraint: difference between residential and commercial counts limited
constraint
  abs(X - Y) <= max_difference;

% Define total cost in thousand dollars (linking variable)
constraint
  total_cost_k = cost_residential_k * X + cost_commercial_k * Y;

% Objective
solve minimize total_cost_k;