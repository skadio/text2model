include "globals.mzn";

/* ---------- Parameters (provided via .dzn file) ----------- */
int: TotalAircrafts;
array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

/* ---------- Decision Variables ----------- */
% Landing time for each aircraft
array[1..TotalAircrafts] of var int: t;

% Early and late deviations 
array[1..TotalAircrafts] of var int: early;
array[1..TotalAircrafts] of var int: late;

% For each pair of distinct aircraft (i<j), a binary decision variable:
% order[i,j] = true means aircraft i lands before aircraft j.
array[1..TotalAircrafts, 1..TotalAircrafts] of var bool: order;

/* ---------- Big-M Computation ---------- */
% Compute a sufficiently large constant M.
int: minET = min(EarliestLandingTime);
int: maxLT = max(LatestLandingTime);
int: maxSep = max([ SeparationTimeMatrix[i,j] | i,j in 1..TotalAircrafts ]);
int: M = (maxLT - minET) + maxSep;

/* ---------- Constraints ----------- */
% Each aircraft must land between its earliest and latest landing times.
constraint forall(i in 1..TotalAircrafts) (
    t[i] >= EarliestLandingTime[i] /\ t[i] <= LatestLandingTime[i]
);

% Define the early and late deviations as piecewise functions:
% If an aircraft lands before its target, early = Target - t, otherwise 0.
constraint forall(i in 1..TotalAircrafts) (
    early[i] = if t[i] <= TargetLandingTime[i] then TargetLandingTime[i] - t[i] else 0 endif /\
    late[i]  = if t[i] >= TargetLandingTime[i] then t[i] - TargetLandingTime[i] else 0 endif
);

% Separation constraints for every pair (i,j) with i < j.
constraint
  forall(i in 1..TotalAircrafts, j in i+1..TotalAircrafts) (
    % If order[i,j] is true then aircraft i lands before j.
    t[j] - t[i] + M * (1 - bool2int(order[i,j])) >= SeparationTimeMatrix[i,j] /\
    % Otherwise, aircraft j lands before i.
    t[i] - t[j] + M * (bool2int(order[i,j])) >= SeparationTimeMatrix[j,i]
);

/* ---------- Objective Function ----------- */
var int: totalPenalty = 
    sum(i in 1..TotalAircrafts)(
        PenaltyTimeBeforeTarget[i] * early[i] + PenaltyTimeAfterTarget[i] * late[i]
    );

/* ---------- Solve Item ----------- */
solve minimize totalPenalty;

/* ---------- Output Block ----------- */
output [
  "Landing Times: ", show(t), "\n",
  "Earliness:    ", show(early), "\n",
  "Lateness:    ", show(late), "\n",
  "Total Penalty: ", show(totalPenalty), "\n"
];