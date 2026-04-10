% Production base raw materials transportation optimization
% Data embedded directly in the model.

int: reqA = 240;   % pieces of raw material A
int: reqB = 80;    % kg of raw material B
int: reqC = 120;   % tons of raw material C

% Per-truck capacities
int: capA_fromA = 4;
int: capB_fromA = 2;
int: capC_fromA = 6;

int: capA_fromB = 7;
int: capB_fromB = 2;
int: capC_fromB = 2;

% Costs per truck
int: cost_fromA = 200;
int: cost_fromB = 160;

% Decision variables: number of trucks dispatched from each warehouse per day
var 0..1000: xA; % trucks from warehouse A
var 0..1000: xB; % trucks from warehouse B

constraint capA_fromA * xA + capA_fromB * xB >= reqA;
constraint capB_fromA * xA + capB_fromB * xB >= reqB;
constraint capC_fromA * xA + capC_fromB * xB >= reqC;

var int: total_cost = cost_fromA * xA + cost_fromB * xB;

solve minimize total_cost;

output [
  "Trucks from warehouse A: ", show(xA), "\n",
  "Trucks from warehouse B: ", show(xB), "\n",
  "Minimum total freight cost (yuan): ", show(total_cost), "\n"
];