include "globals.mzn";

%-----------------------
% Input data
%-----------------------
int: M;                              % number of machines
int: P;                              % number of parts

array[1..M, 1..P] of int: TimeRequired;   % hours per batch of part p on machine m
array[1..M] of float: MachineCosts;       % regular cost per hour on machine m
array[1..M] of int: Availability;         % regular available hours on machine m

array[1..P] of float: Prices;             % revenue per batch of part p
array[1..P] of int: MinBatches;           % minimum batches to produce for part p

array[1..M] of float: ExtraCosts;         % extra cost per hour beyond regular (incremental)
array[1..M] of int: MaxExtra;             % max purchasable extra hours on machine m

%-----------------------
% Decision variables
%-----------------------
% Upper bound for batches: at most we could run all time (regular+extra) of each machine on a part
int: MaxBatchesUB =
  if P = 0 then 0 else
  max(p in 1..P)(
    max(m in 1..M)(
      (Availability[m] + MaxExtra[m]) div max(1, TimeRequired[m,p])
    )
  ) * max(1,P);

array[1..P] of var 0..MaxBatchesUB: Batches;     % batches of each part (100 units per batch)
array[1..M] of var 0..max(MaxExtra): ExtraHours; % purchased extra hours per machine

% Derived: total hours used on each machine
array[1..M] of var int: UsedHours =
  [ sum(p in 1..P)( TimeRequired[m,p] * Batches[p] ) | m in 1..M ];

%-----------------------
% Constraints
%-----------------------
% Contract minimums
constraint forall(p in 1..P)( Batches[p] >= MinBatches[p] );

% Machine capacity with purchasable extra hours
constraint forall(m in 1..M)(
  UsedHours[m] <= Availability[m] + ExtraHours[m]
);

% Extra hours limited per machine
constraint forall(m in 1..M)(
  ExtraHours[m] <= MaxExtra[m]
);

%-----------------------
% Objective: maximize profit
% Profit = revenue - regular machine running cost - extra-hour cost (incremental)
% Regular machine running cost applies to all used hours.
% ExtraCosts is the additional cost per extra hour beyond regular.
%-----------------------
var float: Revenue = sum(p in 1..P)( Prices[p] * int2float(Batches[p]) );

var float: RegularCost =
  sum(m in 1..M)( MachineCosts[m] * int2float(UsedHours[m]) );

var float: ExtraCost =
  sum(m in 1..M)( ExtraCosts[m] * int2float(ExtraHours[m]) );

var float: Profit = Revenue - RegularCost - ExtraCost;

solve maximize Profit;

%-----------------------
% Output
%-----------------------
output [
  "Batches = ", show(Batches), "\n",
  "UsedHours = ", show(UsedHours), "\n",
  "ExtraHours = ", show(ExtraHours), "\n",
  "Revenue = ", show(Revenue), "\n",
  "RegularCost = ", show(RegularCost), "\n",
  "ExtraCost = ", show(ExtraCost), "\n",
  "Profit = ", show(Profit), "\n"
];