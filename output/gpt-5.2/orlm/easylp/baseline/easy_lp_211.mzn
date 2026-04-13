int: TotalResources = 100;

var 0..TotalResources: x; % allocation to department X
var 0..TotalResources: y; % allocation to department Y
var 0..TotalResources: z; % allocation to department Z

constraint x + y + z <= TotalResources;

% X requires at least 10 more than half of Y: x >= y/2 + 10
% Use integer-safe linear form: 2x >= y + 20
constraint 2 * x >= y + 20;

% Combined allocation for Y and Z cannot exceed 60
constraint y + z <= 60;

% Objective: minimize total cost
var int: total_cost = 5 * x + 3 * y + 7 * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];