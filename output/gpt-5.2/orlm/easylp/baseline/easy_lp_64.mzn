% Resource allocation between Project X and Project Y (integer units)

int: costX = 500;
int: costY = 700;

int: effortReq = 2000;   % 2*X + 3*Y >= 2000
int: maxTotal = 1500;    % X + Y <= 1500

var 0..maxTotal: x;      % resources to Project X
var 0..maxTotal: y;      % resources to Project Y

constraint 2*x + 3*y >= effortReq;
constraint x + y <= maxTotal;

var int: totalCost = costX*x + costY*y;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "totalCost=", show(totalCost), "\n"
];