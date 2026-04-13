% Parameters
int: budget = 1000;                 % Maximum total investment allowed
int: min_strategic = 200;           % Lower bound for (X - 2Y + Z)
int: max_balance = 500;             % Upper bound for (2X + Y - Z)

int: costX = 50;                    % Cost per unit investment in project X
int: costY = 30;                    % Cost per unit investment in project Y
int: costZ = 20;                    % Cost per unit investment in project Z

% Variables
var 0..budget: x;                   % Integer units invested in project X
var 0..budget: y;                   % Integer units invested in project Y
var 0..budget: z;                   % Integer units invested in project Z

% Upper bound on total cost: worst case invest 'budget' in each project (safe bound)
var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
% Budget constraint: total investment across X, Y, Z cannot exceed the budget
constraint x + y + z <= budget;

% Strategic requirement: X - 2Y + Z must be at least the minimum strategic threshold
constraint x - 2 * y + z >= min_strategic;

% Balance requirement: 2X + Y - Z must not exceed the maximum balance threshold
constraint 2 * x + y - z <= max_balance;

% Total cost definition: link total_cost to investments and unit costs
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;