% Military resources allocation: tanks vs aircraft
% Minimize cost subject to weight and minimum firepower requirement.

int: maxWeight = 10000;      % tons
int: tankWeight = 3;
int: aircraftWeight = 4;

int: minScore = 2000;        % required minimum
int: tankScoreCoeff = 2;     % score contribution per tank (given as 2x tanks)
int: aircraftScoreCoeff = 1; % score contribution per aircraft (given as 1x aircraft)

int: tankCost = 5000;        % dollars per tank
int: aircraftCost = 3000;    % dollars per aircraft

% Decision variables (integers)
var 0..(maxWeight div tankWeight): tanks;
var 0..(maxWeight div aircraftWeight): aircraft;

% Constraints
constraint tankWeight * tanks + aircraftWeight * aircraft <= maxWeight;
constraint tankScoreCoeff * tanks + aircraftScoreCoeff * aircraft >= minScore;

% Objective: minimize total cost
var int: totalCost = tankCost * tanks + aircraftCost * aircraft;
solve minimize totalCost;

output [
  "tanks = ", show(tanks), "\n",
  "aircraft = ", show(aircraft), "\n",
  "total_weight = ", show(tankWeight * tanks + aircraftWeight * aircraft), " tons\n",
  "score = ", show(tankScoreCoeff * tanks + aircraftScoreCoeff * aircraft), "\n",
  "min_total_cost = $", show(totalCost), "\n"
];