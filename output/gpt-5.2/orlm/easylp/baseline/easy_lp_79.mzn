% Resource allocation / cost minimization for projects X and Y

int: Rmax = 60;          % total resource units available
int: reqX = 2;           % resource units per X
int: reqY = 3;           % resource units per Y
int: minProjects = 10;   % minimum total projects

int: costX = 1000;       % dollars per X
int: costY = 500;        % dollars per Y

var int: X;  % number of X projects
var int: Y;  % number of Y projects

constraint X >= 0 /\ Y >= 0;
constraint reqX * X + reqY * Y <= Rmax;
constraint X + Y >= minProjects;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "TotalCost=", show(totalCost), "\n"
];