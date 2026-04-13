% Teacher allocation optimization (all data embedded)

var 0..100: X; % Math teachers
var 0..100: Y; % Science teachers
var 0..100: Z; % Arts teachers

% Costs per teacher
int: costX = 4;
int: costY = 3;
int: costZ = 2;

% Constraints
constraint X + Y <= 25;
constraint X + Z >= 15;
constraint Y + Z <= 20;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;

output [
  "X(Math)=", show(X), "\n",
  "Y(Science)=", show(Y), "\n",
  "Z(Arts)=", show(Z), "\n",
  "Minimum total cost (rounded)=", show(total_cost), "\n"
];