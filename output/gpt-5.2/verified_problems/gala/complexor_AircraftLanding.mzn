include "globals.mzn";

% -------------------------
% Data (provided in .dzn)
% -------------------------
int: TotalAircrafts;
set of int: A = 1..TotalAircrafts;

array[A] of int: EarliestLandingTime;
array[A] of int: LatestLandingTime;
array[A] of int: TargetLandingTime;
array[A] of int: PenaltyTimeAfterTarget;
array[A] of int: PenaltyTimeBeforeTarget;

array[A, A] of int: SeparationTimeMatrix;

% -------------------------
% Decision variables
% -------------------------
array[A] of var int: LandingTime;
array[A] of var 0..(max(LatestLandingTime) - min(EarliestLandingTime)): Early;
array[A] of var 0..(max(LatestLandingTime) - min(EarliestLandingTime)): Late;
array[A] of var int: Penalty;

% Order variables: Order[k] is the aircraft landing in position k
array[A] of var A: Order;

% -------------------------
% Basic constraints
% -------------------------
constraint all_different(Order);

constraint forall(i in A) (
  EarliestLandingTime[i] <= LandingTime[i] /\
  LandingTime[i] <= LatestLandingTime[i]
);

% Piecewise linear penalty around target time:
% LandingTime = Target - Early + Late, with Early, Late >= 0
constraint forall(i in A) (
  LandingTime[i] = TargetLandingTime[i] - Early[i] + Late[i]
);

constraint forall(i in A) (
  Penalty[i] = PenaltyTimeBeforeTarget[i] * Early[i] + PenaltyTimeAfterTarget[i] * Late[i]
);

% Separation constraints induced by the sequence Order:
% If Order[k] = i and Order[k+1] = j then LandingTime[j] >= LandingTime[i] + sep[i,j]
constraint forall(k in 1..TotalAircrafts-1) (
  let { var int: i = Order[k], var int: j = Order[k+1] } in
    LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i, j]
);

% -------------------------
% Objective
% -------------------------
var int: TotalPenalty = sum(i in A)(Penalty[i]);

solve minimize TotalPenalty;

% -------------------------
% Output
% -------------------------
output [
  "TotalPenalty = ", show(TotalPenalty), "\n",
  "Order = ", show(Order), "\n",
  "LandingTime = ", show(LandingTime), "\n",
  "Early = ", show(Early), "\n",
  "Late = ", show(Late), "\n",
  "Penalty = ", show(Penalty), "\n"
];