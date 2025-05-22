% Parameters
int: TotalAircrafts;
array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

% Variables
array[1..TotalAircrafts] of var int: LandingTime = array1d(1..TotalAircrafts, [EarliestLandingTime[i] | i in 1..TotalAircrafts]);

% Constraints
constraint forall(i in 1..TotalAircrafts, j in i+1..TotalAircrafts) (
  LandingTime[i] + SeparationTimeMatrix[i,j] <= LandingTime[j]
);

constraint forall(i in 1..TotalAircrafts) (
  LandingTime[i] >= EarliestLandingTime[i] /\ LandingTime[i] <= LatestLandingTime[i]
);

% Objective
var int: TotalPenalty = sum(i in 1..TotalAircrafts) (
  if LandingTime[i] > TargetLandingTime[i] then
    (LandingTime[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i]
  else if LandingTime[i] < TargetLandingTime[i] then
    (TargetLandingTime[i] - LandingTime[i]) * PenaltyTimeBeforeTarget[i]
  else
    0
  endif
);

solve minimize TotalPenalty;