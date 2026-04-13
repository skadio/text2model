include "globals.mzn";

% Data (embedded from problem statement)
int: capWide = 25;
int: capNarrow = 15;
int: demand = 900;
int: minWide = 5;

% Decision variables
var 0..1000: wide;
var 0..1000: narrow;
var 0..2000: totalPipes = wide + narrow;

% Constraints
constraint wide >= minWide;
constraint capWide * wide + capNarrow * narrow >= demand;

% "number of wide pipes can be at most a third the number of narrow pipes"
% wide <= narrow / 3  <=>  3*wide <= narrow
constraint 3 * wide <= narrow;

% Objective: minimize total number of pipes
solve minimize totalPipes;

output [
  "wide = ", show(wide), "\n",
  "narrow = ", show(narrow), "\n",
  "totalPipes = ", show(totalPipes), "\n",
  "capacity = ", show(capWide*wide + capNarrow*narrow), "\n"
];