% Auto parts production planning (maximize profit)

%----------------------------
% Parameters (from .dzn)
%----------------------------
int: M; % number of machines
int: P; % number of parts

array[1..M, 1..P] of int: TimeRequired;   % hours per batch on machine m for part p
array[1..M] of int: MachineCosts;         % regular cost per hour for machine m
array[1..M] of int: Availability;         % regular available hours per month for machine m

array[1..P] of int: Prices;               % revenue per batch of part p
array[1..P] of int: MinBatches;           % minimum batches to produce for part p

array[1..M] of float: ExtraCosts;         % extra cost per purchased hour for machine m
array[1..M] of int: MaxExtra;             % max purchasable hours for machine m

%----------------------------
% Decision variables
%----------------------------
array[1..P] of var int: Batches;          % number of batches of each part
array[1..M] of var 0..max(MaxExtra): ExtraHours; % purchased extra hours per machine

%----------------------------
% Constraints
%----------------------------
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  ExtraHours[m] <= MaxExtra[m]
);

constraint forall(m in 1..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]
);

%----------------------------
% Objective: maximize profit
% Profit = Revenue - Regular machine running costs - Extra hour purchase costs
%----------------------------
var float: Profit =
    sum(p in 1..P)(int2float(Prices[p]) * int2float(Batches[p]))
  - sum(m in 1..M)(
        int2float(MachineCosts[m])
        * int2float(sum(p in 1..P)(TimeRequired[m,p] * Batches[p]))
    )
  - sum(m in 1..M)(ExtraCosts[m] * int2float(ExtraHours[m]));

solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "Batches=", show(Batches), "\n",
  "ExtraHours=", show(ExtraHours), "\n"
];