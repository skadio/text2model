% Marketing budget allocation between two channels (integer budgets)

int: maxTotalBudget = 2000;

int: costX = 50;    % $ per unit of effectiveness for channel X
int: costY = 100;   % $ per unit of effectiveness for channel Y

int: minDiff = 500; % required difference in "effort points"

% Decision variables: integer budget allocated to each channel
var 0..maxTotalBudget: x;  % budget/effort units for channel X
var 0..maxTotalBudget: y;  % budget/effort units for channel Y

% Total budget constraint
constraint x + y <= maxTotalBudget;

% Effort relation: "channel X should be three times greater than twice channel Y"
% interpreted as: 3*x - 2*y >= 500
constraint 3 * x - 2 * y >= minDiff;

% Objective: minimize total cost
var 0..(costX*maxTotalBudget + costY*maxTotalBudget): totalCost;
constraint totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];