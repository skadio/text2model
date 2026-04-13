int: TotalAircrafts;
set of int: AC = 1..TotalAircrafts;

array[AC] of int: EarliestLandingTime;
array[AC] of int: LatestLandingTime;
array[AC] of int: TargetLandingTime;
array[AC] of int: PenaltyTimeAfterTarget;
array[AC] of int: PenaltyTimeBeforeTarget;

array[AC, AC] of int: SeparationTimeMatrix;

array[AC] of var int: LandingTime;

constraint
  forall(i in AC) (
    LandingTime[i] >= EarliestLandingTime[i] /\
    LandingTime[i] <= LatestLandingTime[i]
  );

constraint
  forall(i, j in AC where i < j) (
    (LandingTime[i] + SeparationTimeMatrix[i,j] <= LandingTime[j]) \/
    (LandingTime[j] + SeparationTimeMatrix[j,i] <= LandingTime[i])
  );

array[AC] of var int: EarlyTardiness = [ max(0, TargetLandingTime[i] - LandingTime[i]) | i in AC ];
array[AC] of var int: LateTardiness  = [ max(0, LandingTime[i] - TargetLandingTime[i]) | i in AC ];

var int: TotalPenalty =
  sum(i in AC) (
    PenaltyTimeBeforeTarget[i] * EarlyTardiness[i] +
    PenaltyTimeAfterTarget[i]  * LateTardiness[i]
  );

solve minimize TotalPenalty;

output [
  "TotalPenalty=", show(TotalPenalty), "\n",
  "LandingTime=", show(LandingTime), "\n"
];