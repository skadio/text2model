% Parameters
int: costCommercial = 150000;     % Cost per commercial building (X) in dollars
int: costResidential = 200000;    % Cost per residential complex (Y) in dollars
int: maxProperties = 10;          % Maximum total number of properties (X + Y)
int: minDiversification = 5;      % Minimum diversification threshold for X + 0.5*Y

% Variables
var 0..maxProperties: x;          % Number of commercial buildings (whole units)
var 0..maxProperties: y;          % Number of residential complexes (whole units)
var 0..(maxProperties * max(costCommercial, costResidential)): totalInvestment; % Total investment in dollars

% Constraints
% Property count limit (maximum total number of properties)
constraint
  x + y <= maxProperties;

% Diversification requirement: x + 0.5*y >= minDiversification
% Multiply by 2 to keep everything integral: 2*x + y >= 2*minDiversification
constraint
  2 * x + y >= 2 * minDiversification;

% Define total investment as linear combination of chosen properties
constraint
  totalInvestment = costCommercial * x + costResidential * y;

% Objective
solve minimize totalInvestment;