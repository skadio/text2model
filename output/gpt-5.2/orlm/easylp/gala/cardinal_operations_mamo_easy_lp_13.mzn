% Energy investment planning: minimize cost with integer unit investments

% Data (embedded from problem statement)
int: costSolar = 4;
int: costWind  = 5;

int: aSolar = 3;      % contribution coefficient in portfolio constraint
int: aWind  = 2;
int: minMW  = 10;

int: maxDiffMW = 5;   % |solar - wind| <= 5

% Decision variables: whole-number units of projects
% Upper bounds chosen safely (smallest solutions will be well below these)
var 0..100: solarUnits;
var 0..100: windUnits;

% Constraints
constraint aSolar * solarUnits + aWind * windUnits >= minMW;
constraint abs(solarUnits - windUnits) <= maxDiffMW;

% Objective: minimize total investment cost
var int: totalCost = costSolar * solarUnits + costWind * windUnits;

solve minimize totalCost;

output [
  "solarUnits = ", show(solarUnits), "\n",
  "windUnits  = ", show(windUnits), "\n",
  "totalCost  = $", show(totalCost), "\n"
];