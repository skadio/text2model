int: TotalAircrafts;

array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

array[1..TotalAircrafts] of var int: landingTime;

constraint
  forall(i in 1..TotalAircrafts) (
    landingTime[i] >= EarliestLandingTime[i] /\
    landingTime[i] <= LatestLandingTime[i]
  );

constraint
  forall(i in 1..TotalAircrafts, j in i+1..TotalAircrafts) (
    (landingTime[i] + SeparationTimeMatrix[i][j] <= landingTime[j]) \/
    (landingTime[j] + SeparationTimeMatrix[j][i] <= landingTime[i])
  );

var int: totalPenalty = sum(i in 1..TotalAircrafts) (
  if landingTime[i] > TargetLandingTime[i] then
    (landingTime[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i]
  else
    (TargetLandingTime[i] - landingTime[i]) * PenaltyTimeBeforeTarget[i]
);

solve minimize totalPenalty;

output [
  "Landing times: ", show(landingTime), "\n",
  "Total penalty: ", show(totalPenalty), "\n"
];