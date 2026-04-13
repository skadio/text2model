% Resource allocation among departments X, Y, Z
% Minimize total cost subject to constraints

int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Decision variables: integer resource units allocated
var int: X;
var int: Y;
var int: Z;

% Constraints
constraint X + Y >= 50;        % minimum service level
constraint X + Z <= 100;       % budget restriction
constraint Y - Z >= 10;        % prioritize Y over Z

% Non-negativity (implicit in "allocation" context)
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];