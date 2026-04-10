% Parameters
int: TotalAircrafts;                             % number of aircraft
set of int: AIRCRAFT = 1..TotalAircrafts;        % index set for aircraft

array[AIRCRAFT] of int: EarliestLandingTime;     % earliest feasible landing time for each aircraft
array[AIRCRAFT] of int: LatestLandingTime;       % latest feasible landing time for each aircraft
array[AIRCRAFT] of int: TargetLandingTime;       % target (preferred) landing time for each aircraft

array[AIRCRAFT] of int: PenaltyTimeAfterTarget;  % penalty per unit time landing after target
array[AIRCRAFT] of int: PenaltyTimeBeforeTarget; % penalty per unit time landing before target

array[AIRCRAFT, AIRCRAFT] of int: SeparationTimeMatrix; % required separation time i before j


% Variables
array[AIRCRAFT] of var int: LandingTime;         % chosen landing time for each aircraft

array[AIRCRAFT] of var int: EarlyDeviation;      % how much aircraft lands before target (>=0)
array[AIRCRAFT] of var int: LateDeviation;       % how much aircraft lands after target (>=0)

var int: TotalPenalty;                           % total weighted deviation penalty (objective)


% Constraints

%--- Landing time windows (feasibility bounds)
constraint
  forall(a in AIRCRAFT) (
    EarliestLandingTime[a] <= LandingTime[a] /\
    LandingTime[a] <= LatestLandingTime[a]
  );

%--- Deviation variable domains (non-negativity)
constraint
  forall(a in AIRCRAFT) (
    EarlyDeviation[a] >= 0 /\
    LateDeviation[a]  >= 0
  );

%--- Link deviations to landing times relative to target time
% EarlyDeviation = max(0, Target - Landing)
% LateDeviation  = max(0, Landing - Target)
% Using linear constraints: Early >= Target-Landing, Late >= Landing-Target,
% and (Landing-Target) = Late - Early ensures the correct max(0,·) behavior.
constraint
  forall(a in AIRCRAFT) (
    EarlyDeviation[a] >= TargetLandingTime[a] - LandingTime[a] /\
    LateDeviation[a]  >= LandingTime[a] - TargetLandingTime[a] /\
    (LandingTime[a] - TargetLandingTime[a]) = LateDeviation[a] - EarlyDeviation[a]
  );

%--- Pairwise separation constraints (either i lands before j with required separation, or vice versa)
% For each unordered pair (i,j), enforce one of the two possible orders.
constraint
  forall(i, j in AIRCRAFT where i < j) (
    (LandingTime[i] + SeparationTimeMatrix[i, j] <= LandingTime[j]) \/
    (LandingTime[j] + SeparationTimeMatrix[j, i] <= LandingTime[i])
  );

%--- Total penalty definition (weighted sum of deviations)
constraint
  TotalPenalty =
    sum(a in AIRCRAFT) (
      PenaltyTimeBeforeTarget[a] * EarlyDeviation[a] +
      PenaltyTimeAfterTarget[a]  * LateDeviation[a]
    );


% Objective
solve minimize TotalPenalty;