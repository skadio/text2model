include "globals.mzn";

% Decision variables (integer improvements)
var 0..1000: bandwidth;   % units of improvement in bandwidth
var 0..1000: latencyRed;  % units of reduction in latency

% Resource cost per unit
int: costBandwidth = 5;
int: costLatency   = 10;

% Constraints from the description
constraint 2 * bandwidth + latencyRed >= 200;
constraint 3 * bandwidth + latencyRed <= 500;

% Objective: minimize total resource cost
var int: totalCost = costBandwidth * bandwidth + costLatency * latencyRed;

solve minimize totalCost;

output [
  "Minimum total resource cost = ", show(totalCost), "\n",
  "Bandwidth improvement = ", show(bandwidth), "\n",
  "Latency reduction = ", show(latencyRed), "\n"
];