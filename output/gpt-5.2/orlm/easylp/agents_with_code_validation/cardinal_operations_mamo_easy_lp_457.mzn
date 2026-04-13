% Parameters
% Unit costs (USD per resource unit)
int: costX = 5000;
int: costY = 8000;

% Resource/portfolio limits (units)
int: maxCombinedUnits = 100;      % X + Y <= 100
int: minXMoreThanY = 20;          % X >= Y + 20
int: maxPortfolioUnits = 150;     % X + 2Y <= 150


% Variables
% Resource units allocated to each project (must be whole numbers)
var 0..maxCombinedUnits: xUnits;
var 0..maxCombinedUnits: yUnits;


% Constraints
% Combined resource availability constraint
constraint xUnits + yUnits <= maxCombinedUnits;

% Diversification / balance constraint
constraint xUnits >= yUnits + minXMoreThanY;

% Portfolio-wide constraint
constraint xUnits + 2 * yUnits <= maxPortfolioUnits;


% Objective
% Minimize total cost of allocated resources
solve minimize costX * xUnits + costY * yUnits;