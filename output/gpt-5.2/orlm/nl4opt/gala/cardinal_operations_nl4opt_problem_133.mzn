% Metal extraction optimization (embed all data in model)

% Data
int: metal_J = 5;
int: water_J = 8;
int: poll_J  = 3;

int: metal_P = 9;
int: water_P = 6;
int: poll_P  = 5;

int: maxWater = 1500;
int: maxPoll  = 1350;

% Decision variables: number of each process (nonnegative integers)
% Safe upper bounds from individual resource limits
var 0..(maxWater div water_J): J;
var 0..(maxWater div water_P): P;

% Resource constraints
constraint water_J * J + water_P * P <= maxWater;
constraint poll_J  * J + poll_P  * P <= maxPoll;

% Objective: maximize extracted metal
var int: totalMetal = metal_J * J + metal_P * P;

solve maximize totalMetal;

output [
  "J = ", show(J), "\n",
  "P = ", show(P), "\n",
  "TotalMetal = ", show(totalMetal), "\n",
  "WaterUsed = ", show(water_J*J + water_P*P), " / ", show(maxWater), "\n",
  "Pollution = ", show(poll_J*J + poll_P*P), " / ", show(maxPoll), "\n"
];