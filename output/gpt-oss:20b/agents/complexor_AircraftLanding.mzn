include "globals.mzn";

/* --- Input data ------------------------------------------------------- */
int: TotalAircrafts;

array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

/* --- Decision variables ------------------------------------------------ */
array[1..TotalAircrafts] of var EarliestLandingTime[i] .. LatestLandingTime[i] : start;

array[1..TotalAircrafts] of int: dur = [1 | i in 1..TotalAircrafts];
array[1..TotalAircrafts] of int: use = [1 | i in 1..TotalAircrafts];
int: cap = 1;

constraint cumulative(start, dur, use, cap);

/* --- Temporal windows --------------------------------------------------- */
constraint forall(i in 1..TotalAircrafts) (
    start[i] >= EarliestLandingTime[i] /\ start[i] <= LatestLandingTime[i]
);

/* --- Separation constraints ------------------------------------------- */
constraint forall(i in 1..TotalAircrafts, j in i+1..TotalAircrafts) (
    (start[j] >= start[i] + SeparationTimeMatrix[i][j]) \/
    (start[i] >= start[j] + SeparationTimeMatrix[j][i])
);

/* --- Penalty calculation ---------------------------------------------- */
array[1..TotalAircrafts] of var int: penalty;
constraint forall(i in 1..TotalAircrafts) (
    penalty[i] =
        if start[i] >= TargetLandingTime[i]
        then (start[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i]
        else (TargetLandingTime[i] - start[i]) * PenaltyTimeBeforeTarget[i]
        endif
);

var int: totalPenalty = sum(i in 1..TotalAircrafts) penalty[i];

/* --- Objective -------------------------------------------------------- */
solve minimize totalPenalty;

/* --- Output ------------------------------------------------------------ */
output [
    "Start times: ", show(start), "\n",
    "Penalties:   ", show(penalty), "\n",
    "Total penalty: ", show(totalPenalty), "\n"
];