% Parameters (with values embedded)
int: costX = 150000;  % commercial building cost
int: costY = 200000;  % residential complex cost
int: maxProps = 10;   % total properties upper bound
int: minDiversified = 5;

% Variables
var 0..maxProps: X;   % number of commercial buildings
var 0..maxProps: Y;   % number of residential complexes

% Constraints
constraint X + Y <= maxProps;
% Diversification: X + 0.5*Y >= 5  ->  2*X + Y >= 10
constraint 2 * X + Y >= 2 * minDiversified;

% Objective
var 0..(maxProps * max(costX, costY)): total_investment;
constraint total_investment = costX * X + costY * Y;

solve minimize total_investment;