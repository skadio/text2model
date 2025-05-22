% Parameters
int: TotalAircrafts;

array[1..TotalAircrafts] of int: EarliestLandingTime;
array[1..TotalAircrafts] of int: LatestLandingTime;
array[1..TotalAircrafts] of int: TargetLandingTime;
array[1..TotalAircrafts] of int: PenaltyTimeAfterTarget;
array[1..TotalAircrafts] of int: PenaltyTimeBeforeTarget;
array[1..TotalAircrafts, 1..TotalAircrafts] of int: SeparationTimeMatrix;

% Derived constants for Big-M construction
int: MaxLatestLandingTime  = max(i in 1..TotalAircrafts)(LatestLandingTime[i]);
int: MinEarliestLandingTime = min(i in 1..TotalAircrafts)(EarliestLandingTime[i]);
int: MaxSeparationTime      = max(i, j in 1..TotalAircrafts)(SeparationTimeMatrix[i,j]);
int: BigM = (MaxLatestLandingTime - MinEarliestLandingTime) + MaxSeparationTime;

% Variables
array[1..TotalAircrafts] of var int: LandingTime;

array[1..TotalAircrafts] of var int: EarlyDeviation;   % minutes landed before target
array[1..TotalAircrafts] of var int: LateDeviation;    % minutes landed after  target

array[1..TotalAircrafts, 1..TotalAircrafts] of var bool: Before;  % Before[i,j] = true iff aircraft i lands before j

var int: TotalPenalty;

% Constraints
% 1. Landing time windows
constraint
  forall(i in 1..TotalAircrafts) (
      EarliestLandingTime[i] <= LandingTime[i] /\
      LandingTime[i] <= LatestLandingTime[i]
  );

% 2. Define earliness and lateness with respect to target
constraint
  forall(i in 1..TotalAircrafts) (
      LandingTime[i] + EarlyDeviation[i] - LateDeviation[i] = TargetLandingTime[i]
  );

% 3. Bounds on earliness and lateness deviations
constraint
  forall(i in 1..TotalAircrafts) (
      0 <= EarlyDeviation[i] /\ EarlyDeviation[i] <= TargetLandingTime[i] - EarliestLandingTime[i] /\
      0 <= LateDeviation[i]  /\ LateDeviation[i]  <= LatestLandingTime[i]  - TargetLandingTime[i]
  );

% 4. Symmetry and diagonals for ordering variables
constraint
  forall(i in 1..TotalAircrafts) (
      Before[i,i] = false
  );

constraint
  forall(i, j in 1..TotalAircrafts where i < j) (
      bool2int(Before[i,j]) + bool2int(Before[j,i]) = 1
  );

% 5. Separation requirements using Big-M
constraint
  forall(i, j in 1..TotalAircrafts where i <> j) (
      LandingTime[j] - LandingTime[i] + BigM * (1 - bool2int(Before[i,j]))
      >= SeparationTimeMatrix[i,j]
  );

% Objective
constraint
  TotalPenalty = sum(i in 1..TotalAircrafts)(
                    PenaltyTimeBeforeTarget[i] * EarlyDeviation[i] +
                    PenaltyTimeAfterTarget[i]  * LateDeviation[i]
                );

solve minimize TotalPenalty;