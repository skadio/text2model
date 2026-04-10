% Parameters
int: B = 5000;          % Total budget cap in dollars
int: min_diff = 1000;   % Minimum value of (2X - Y) in dollars
int: max_diff = 2000;   % Maximum value of (X - 3Y) in dollars
int: costX = 1000;      % Cost per unit of channel X
int: costY = 1500;      % Cost per unit of channel Y

% Variables
var 0..(B div costX): x;  % Integer units of effectiveness for channel X
var 0..(B div costY): y;  % Integer units of effectiveness for channel Y
var 0..B: spend;          % Total expenditure in dollars

% Constraints
constraint costX * x + costY * y <= B;
constraint 2 * (costX * x) - (costY * y) >= min_diff;
constraint (costX * x) - 3 * (costY * y) <= max_diff;
constraint spend = costX * x + costY * y;

% Objective
solve minimize spend;