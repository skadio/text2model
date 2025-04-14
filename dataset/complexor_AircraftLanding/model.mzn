% ============================================================
% AIRCRAFT LANDING PROBLEM (ALP)
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% The goal is to determine optimal landing times for a set of aircraft
% while minimizing penalties due to deviations from target landing times.
%
% - Each aircraft must land within a given time window.
% - Each aircraft has a target landing time.
% - Landing too early or too late incurs a penalty.
% - There is a required separation time between landings.
%
% OBJECTIVE:
% ----------
% Minimize the total penalty while ensuring all constraints are met.
%
% PARAMETERS PROVIDED IN JSON:
% {
%     "TotalAircrafts": <int>,
%     "EarliestLandingTime": [...],
%     "LatestLandingTime": [...],
%     "TargetLandingTime": [...],
%     "PenaltyTimeAfterTarget": [...],
%     "PenaltyTimeBeforeTarget": [...],
%     "SeparationTimeMatrix": [..., ...]
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: TotalAircrafts;

array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;

array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;

array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------
% x[i] = actual landing time for aircraft i
% Must lie within [EarliestLandingTime[i], LatestLandingTime[i]].
array[1..TotalAircrafts] of var int: LandingTimes;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Each aircraft i must land between its earliest and latest times.
constraint
  forall(i in 1..TotalAircrafts) (
    LandingTimes[i] >= EarliestLandingTime[i] /\ LandingTimes[i] <= LatestLandingTime[i]
  );

% (C2) Separation: for i < j, aircraft j lands after i by at least
%     SeparationTimeMatrix[i,j].
constraint
  forall(i, j in 1..TotalAircrafts where i < j) (
    LandingTimes[j] >= LandingTimes[i] + SeparationTimeMatrix[i,j]
  );


% -----------------------------
% 4) PENALTY CALCULATION
% -----------------------------
% Penalty[i] = cost if aircraft i lands before or after target time.
% We use a piecewise expression to handle "before" vs. "after" target.
array[1..TotalAircrafts] of var int: Penalty;

constraint
  forall(i in 1..TotalAircrafts) (
    Penalty[i] =
      if LandingTimes[i] <= TargetLandingTime[i] then
         PenaltyTimeBeforeTarget[i] * (TargetLandingTime[i] - LandingTimes[i])
      else
         PenaltyTimeAfterTarget[i] * (LandingTimes[i] - TargetLandingTime[i])
      endif
  );


% -----------------------------
% 5) OBJECTIVE FUNCTION
% -----------------------------

% Minimize the sum of penalties over all aircraft.
var int: TotalPenalty = sum(i in 1..TotalAircrafts) (Penalty[i]);
solve minimize TotalPenalty;


% -----------------------------
% 6) OUTPUT
% -----------------------------

% Print the landing schedule, penalties, and total penalty
output [
    "Optimal Aircraft Landing Schedule:\n",
    forall(i in 1..TotalAircrafts) (
        concat([
            "  Aircraft ", show(i), ": Lands at ", show(LandingTimes[i]),
            " (Penalty: ", show(Penalty[i]), ")\n"
        ])
    ),
    "Total Penalty: ", show(TotalPenalty), "\n"
];
