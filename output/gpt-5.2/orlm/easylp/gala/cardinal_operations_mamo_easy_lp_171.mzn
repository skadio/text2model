% Marketing budget allocation (integer)
% Minimize total cost subject to channel-pair constraints.

include "globals.mzn";

% Decision variables: dollars invested in each channel (whole numbers)
var 0..1000: x;   % Channel X
var 0..1000: y;   % Channel Y
var 0..1000: z;   % Channel Z

% Constraints from the description
constraint x + y <= 1000;
constraint y + z <= 800;
constraint x + z >= 500;

% ROI coefficients (given, but no ROI target is specified in the problem text)
int: roiX = 2;
int: roiY = 3;
int: roiZ = 5;
var 0..(roiX*1000 + roiY*1000 + roiZ*1000): totalROI = roiX*x + roiY*y + roiZ*z;

% Objective: minimize total cost (total spend)
var 0..3000: totalCost = x + y + z;
solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "TotalCost = ", show(totalCost), "\n",
  "TotalROI = ", show(totalROI), "\n"
];