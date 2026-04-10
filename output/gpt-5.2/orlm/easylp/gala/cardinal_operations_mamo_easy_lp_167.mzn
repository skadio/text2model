% Marketing budget allocation (integer dollars) minimizing expected returns

int: budget_max = 1000;

int: min_diff_XY = 100;   % X >= Y + 100
int: min_diff_YZ = 50;    % Y >= Z + 50

int: rX = 10;             % returns per dollar
int: rY = 15;
int: rZ = 20;

% Decision variables: whole dollars
var 0..budget_max: X;
var 0..budget_max: Y;
var 0..budget_max: Z;

% Constraints
constraint X + Y + Z <= budget_max;
constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

% Objective: minimize total expected returns
var 0..(budget_max * max([rX,rY,rZ])): total_return;
constraint total_return = rX * X + rY * Y + rZ * Z;

solve minimize total_return;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "Total return (units) = ", show(total_return), "\n"
];