include "globals.mzn";

int: TotalAircrafts;

set of int: A = 1..TotalAircrafts;

array[A] of int: EarliestLandingTime;
array[A] of int: LatestLandingTime;
array[A] of int: TargetLandingTime;
array[A] of int: PenaltyTimeAfterTarget;
array[A] of int: PenaltyTimeBeforeTarget;

array[A, A] of int: SeparationTimeMatrix;

% Decision variables: landing time for each aircraft
array[A] of var int: LandingTime;

% Bounds
constraint forall(i in A) (
  LandingTime[i] >= EarliestLandingTime[i] /\
  LandingTime[i] <= LatestLandingTime[i]
);

% Pairwise ordering variables (i lands before j)
array[A, A] of var bool: before;

constraint forall(i in A) (before[i,i] = false);

% Exactly one order for each pair
constraint forall(i, j in A where i < j) (
  before[i,j] xor before[j,i]
);

% Separation constraints implied by the chosen order
constraint forall(i, j in A where i != j) (
  before[i,j] -> LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i,j]
);

% Penalty for deviating from target time
array[A] of var int: Early;
array[A] of var int: Late;
array[A] of var int: Penalty;

constraint forall(i in A) (
  Early[i] >= TargetLandingTime[i] - LandingTime[i] /\
  Early[i] >= 0 /\
  Late[i]  >= LandingTime[i] - TargetLandingTime[i] /\
  Late[i]  >= 0 /\
  Penalty[i] = PenaltyTimeBeforeTarget[i] * Early[i] + PenaltyTimeAfterTarget[i] * Late[i]
);

var int: TotalPenalty = sum(i in A)(Penalty[i]);

solve minimize TotalPenalty;

output [
  "TotalPenalty = ", show(TotalPenalty), "\n",
  "LandingTime = ", show(LandingTime), "\n"
];