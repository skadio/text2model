% Parameters
% All data is embedded directly in the model as required.

int: min_total_properties = 50;            % X + Y >= 50
int: max_weighted_properties = 120;        % 2*X + Y <= 120
int: min_balance = 10;                     % X - 3*Y >= 10

int: min_residential = 20;                 % X >= 20
int: min_commercial = 10;                  % Y >= 10

int: cost_residential = 5000;              % cost per unit of residential investment
int: cost_commercial = 3000;               % cost per unit of commercial investment

% Safe upper bounds derived from constraints:
% From 2*X + Y <= 120 and Y >= 10 => X <= (120-10)/2 = 55
int: max_residential = 55;
% From 2*X + Y <= 120 and X >= 20 => Y <= 120 - 40 = 80
int: max_commercial = 80;

% Variables
var min_residential..max_residential: X;   % number of residential properties (integer units)
var min_commercial..max_commercial: Y;     % number of commercial properties (integer units)

var int: total_cost;                       % total investment cost in dollars

% Constraints
% Define total cost
constraint
  total_cost = cost_residential * X + cost_commercial * Y;

% Total number of properties must meet expansion goals
constraint
  X + Y >= min_total_properties;

% Budget/market constraint on weighted combination of investments
constraint
  2 * X + Y <= max_weighted_properties;

% Portfolio balance requirement
constraint
  X - 3 * Y >= min_balance;

% Minimum investment requirements are enforced by variable bounds:
%   X >= min_residential, Y >= min_commercial

% Objective
solve minimize total_cost;