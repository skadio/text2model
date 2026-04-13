% Aircraft Landing Problem (MiniZinc)

% Parameters
int: TotalAircrafts;

array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;

array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

% Helper bounds
int: minT = min(EarliestLandingTime);
int: maxT = max(LatestLandingTime);

% Variables
array[1..TotalAircrafts] of var minT..maxT: LandingTime;
array[1..TotalAircrafts] of var 0..(maxT - minT): Early;
array[1..TotalAircrafts] of var 0..(maxT - minT): Late;

% Constraints
constraint
  forall(i in 1..TotalAircrafts) (
    EarliestLandingTime[i] <= LandingTime[i] /\ LandingTime[i] <= LatestLandingTime[i]
  );

% Deviation from target split into Early/Late
constraint
  forall(i in 1..TotalAircrafts) (
    LandingTime[i] - TargetLandingTime[i] = Late[i] - Early[i]
  );

% Separation (disjunctive) constraints
constraint
  forall(i, j in 1..TotalAircrafts where i < j) (
    (LandingTime[i] + SeparationTimeMatrix[i, j] <= LandingTime[j]) \/
    (LandingTime[j] + SeparationTimeMatrix[j, i] <= LandingTime[i])
  );

% Objective: minimize total weighted earliness/tardiness
solve minimize
  sum(i in 1..TotalAircrafts) (
    PenaltyTimeBeforeTarget[i] * Early[i] + PenaltyTimeAfterTarget[i] * Late[i]
  );