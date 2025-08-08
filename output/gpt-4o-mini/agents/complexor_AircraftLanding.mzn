include "globals.mzn";

int: TotalAircrafts;
array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

/* Variables */
array[1..TotalAircrafts] of var int: landingTimes;

/* Constraints */
constraint forall(i in 1..TotalAircrafts)(
    landingTimes[i] >= EarliestLandingTime[i] /\ 
    landingTimes[i] <= LatestLandingTime[i]
);

constraint increasing(landingTimes);

/* Penalty Calculation */
var int: totalPenalty = sum(i in 1..TotalAircrafts)(
    (landingTimes[i] > TargetLandingTime[i]) * (landingTimes[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i] +
    (landingTimes[i] < TargetLandingTime[i]) * (TargetLandingTime[i] - landingTimes[i]) * PenaltyTimeBeforeTarget[i])
);

/* Separation Constraints */
constraint forall(i, j in 1..TotalAircrafts where i < j)(
    landingTimes[j] - landingTimes[i] >= SeparationTimeMatrix[i, j]
);

/* Solve & output */
solve minimize totalPenalty;
output [ "Landing Times = ", show(landingTimes), "\nTotal Penalty = ", show(totalPenalty), "\n" ];