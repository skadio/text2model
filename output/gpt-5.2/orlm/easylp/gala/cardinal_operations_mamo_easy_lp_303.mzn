% Environmental projects resource minimization (integer LP)

include "globals.mzn";

% Decision variables: effort units (whole numbers)
var 0..1000: x; % Project X effort
var 0..1000: y; % Project Y effort
var 0..1000: z; % Project Z effort

% Constraints
constraint x + y >= 10;
constraint 2*x + z <= 15;
constraint y - z >= 5;

% Objective: minimize total resource requirement
% Resource coefficients: X=2, Y=3, Z=1
var 0..100000: total_resource = 2*x + 3*y + 1*z;

solve minimize total_resource;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_resource=", show(total_resource), "\n"
];