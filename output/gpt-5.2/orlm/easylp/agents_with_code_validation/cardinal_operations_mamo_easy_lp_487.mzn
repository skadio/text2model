% Parameters
% Unit costs ($/unit)
int: costX = 20;
int: costY = 30;

% Global resource/budget constraints
int: totalMax = 1000;         % x + y <= 1000
int: diffMin  = 200;          % |x - y| >= 200 (modeled via disjunction)
int: weightedMax = 1500;      % 2*x + y <= 1500

% Project-specific upper bounds
int: xMax = 800;
int: yMax = 600;

% Variables
var 0..xMax: x;               % units allocated to Project X (integer, nonnegative)
var 0..yMax: y;               % units allocated to Project Y (integer, nonnegative)

% Total cost in dollars (upper bound based on max allocations)
var 0..(costX * xMax + costY * yMax): totalCost;

% Constraints
% Link total cost to decision variables (linear cost expression)
constraint totalCost = costX * x + costY * y;

% Global resource/budget limits
constraint x + y <= totalMax;          % total allocation cap
constraint 2 * x + y <= weightedMax;   % weighted allocation cap

% Balance requirement: allocations must differ by at least diffMin
constraint (x - y >= diffMin) \/ (y - x >= diffMin);

% Objective
solve minimize totalCost;