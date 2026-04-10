% Budget allocation between departments X, Y, Z (integer dollars)

% Data (embedded as required)
int: Bmax = 5000;                 % total budget limit ($)
int: cX = 10; int: cY = 20; int: cZ = 30;   % cost per unit
int: effReq = 10000;              % effectiveness requirement ($)
int: diffMax = 1500;              % max allowed difference between X and Z budgets ($)

% Decision variables: number of units allocated to each department
var 0..Bmax div cX: x;
var 0..Bmax div cY: y;
var 0..Bmax div cZ: z;

% Total cost in dollars
var 0..Bmax: totalCost = cX*x + cY*y + cZ*z;

% Constraints
constraint totalCost <= Bmax;

% Effectiveness: 5 units of X and 10 units of Y must generate at least $10000
% (modeled as 5*x + 10*y >= 10000)
constraint 5*x + 10*y >= effReq;

% Budget difference between X and Z (in dollars) not to exceed $1500
constraint abs(cX*x - cZ*z) <= diffMax;

solve minimize totalCost;

output [
  "Minimum total cost ($): ", show(totalCost), "\n",
  "x units: ", show(x), " (X budget $", show(cX*x), ")\n",
  "y units: ", show(y), " (Y budget $", show(cY*y), ")\n",
  "z units: ", show(z), " (Z budget $", show(cZ*z), ")\n"
];