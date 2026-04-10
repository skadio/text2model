% Parameters
int: budgetMax = 10;                 % Maximum allowed value of 4*X + 1*Y
int: strategicMin = 6;               % Minimum required value of 1*X + 2*Y

int: coeffBudgetX = 4;               % Coefficient of X in budget constraint
int: coeffBudgetY = 1;               % Coefficient of Y in budget constraint
int: coeffStrategicX = 1;            % Coefficient of X in strategic constraint
int: coeffStrategicY = 2;            % Coefficient of Y in strategic constraint

int: costX = 7;                      % Cost per unit invested in project X
int: costY = 3;                      % Cost per unit invested in project Y


% Variables
var 0..budgetMax: x;                 % Whole units allocated to project X (nonnegative)
var 0..budgetMax: y;                 % Whole units allocated to project Y (nonnegative)

var 0..(costX*budgetMax + costY*budgetMax): totalCost;  % Total cost to minimize


% Constraints
% Budget feasibility: 4*X + 1*Y cannot exceed the maximum budget
constraint
  coeffBudgetX * x + coeffBudgetY * y <= budgetMax;

% Strategic requirement: 1*X + 2*Y must be at least the minimum target
constraint
  coeffStrategicX * x + coeffStrategicY * y >= strategicMin;

% Total cost definition: totalCost equals the linear cost of investments
constraint
  totalCost = costX * x + costY * y;


% Objective
solve minimize totalCost;