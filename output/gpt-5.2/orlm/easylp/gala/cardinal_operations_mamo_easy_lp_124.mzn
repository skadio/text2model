% Resource allocation for Program X and Program Y (integer decision variables)

% Data (embedded from problem description)
int: costX = 5;
int: costY = 3;

int: minSupport = 50;   % 2*X + 4*Y >= 50
int: maxLimit  = 30;   % 3*X + 1*Y <= 30

% Decision variables: whole numbers of resources
var 0..1000: x;  % Program X resources
var 0..1000: y;  % Program Y resources

% Constraints
constraint 2*x + 4*y >= minSupport;
constraint 3*x + y <= maxLimit;

% Objective: minimize total resource expenditure
var 0..1000000: totalCost = costX*x + costY*y;
solve minimize totalCost;

output [
  "Program X resources (x) = ", show(x), "\n",
  "Program Y resources (y) = ", show(y), "\n",
  "Minimum total resources (cost) = ", show(totalCost), "\n"
];