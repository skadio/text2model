% Parameters
int: TotalAircrafts; % The total number of aircraft in the set
array[1..TotalAircrafts] of int: EarliestLandingTime; % The earliest landing time for each aircraft
array[1..TotalAircrafts] of int: LatestLandingTime; % The latest landing time for each aircraft
array[1..TotalAircrafts] of int: TargetLandingTime; % The target landing time for each aircraft
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget; % The penalty incurred for each aircraft per unit landing after the target time
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget; % The penalty incurred for each aircraft per unit landing before the target time
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix; % The required separation time between the landing of aircraft i and aircraft j

% Variables
array[1..TotalAircrafts] of var EarliestLandingTime[1]..LatestLandingTime[TotalAircrafts]: LandingTime; % The landing time for each aircraft

% Constraints

% Each aircraft must land within its given time window
constraint forall(i in 1..TotalAircrafts) (
  LandingTime[i] >= EarliestLandingTime[i] /\ LandingTime[i] <= LatestLandingTime[i]
);

% The landing time of each aircraft must maintain a required separation time from other aircraft
constraint forall(i in 1..TotalAircrafts, j in 1..TotalAircrafts where i != j) (
  if LandingTime[i] < LandingTime[j] then
    LandingTime[j] - LandingTime[i] >= SeparationTimeMatrix[i,j]
  else
    LandingTime[i] - LandingTime[j] >= SeparationTimeMatrix[j,i]
  endif
);

% The penalty for landing too early or too late is proportional to the time difference from the target landing time
constraint forall(i in 1..TotalAircrafts) (
  if LandingTime[i] < TargetLandingTime[i] then
    (TargetLandingTime[i] - LandingTime[i]) * PenaltyTimeBeforeTarget[i] >= 0
  else
    (LandingTime[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i] >= 0
  endif
);

% Objective
solve minimize sum(i in 1..TotalAircrafts) (
  if LandingTime[i] < TargetLandingTime[i] then
    (TargetLandingTime[i] - LandingTime[i]) * PenaltyTimeBeforeTarget[i]
  else
    (LandingTime[i] - TargetLandingTime[i]) * PenaltyTimeAfterTarget[i]
  endif
);