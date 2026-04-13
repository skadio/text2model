% Railway infrastructure planning: trains vs trams

% Data (embedded as required)
int: trainCapacity = 120;   % people per hour per train
int: tramCapacity  = 30;    % people per hour per tram
int: demand        = 600;   % minimum people per hour required

% Decision variables
var 0..ceil(demand div trainCapacity): trains;
var 0..ceil(demand div tramCapacity):  trams;

% Constraints
constraint trams >= 2 * trains;
constraint trainCapacity * trains + tramCapacity * trams >= demand;

% Objective: minimize total units
var 0..1000: totalUnits = trains + trams;
solve minimize totalUnits;

output [
  "trains = ", show(trains), "\n",
  "trams  = ", show(trams), "\n",
  "totalUnits = ", show(totalUnits), "\n",
  "capacity = ", show(trainCapacity * trains + tramCapacity * trams), "\n"
];