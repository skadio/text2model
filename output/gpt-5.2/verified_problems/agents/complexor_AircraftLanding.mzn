% Parameters
int: TotalAircrafts; % number of aircraft

set of int: AIRCRAFT = 1..TotalAircrafts; % index set for aircraft

array[AIRCRAFT] of int: EarliestLandingTime; % earliest feasible landing time for each aircraft
array[AIRCRAFT] of int: LatestLandingTime;   % latest feasible landing time for each aircraft
array[AIRCRAFT] of int: TargetLandingTime;   % target landing time for each aircraft

array[AIRCRAFT] of int: PenaltyTimeAfterTarget;  % penalty per unit time after target
array[AIRCRAFT] of int: PenaltyTimeBeforeTarget; % penalty per unit time before target

array[AIRCRAFT, AIRCRAFT] of int: SeparationTimeMatrix; % required separation time i then j

% Useful derived bounds (for variable domains)
int: MinEarliest = min(i in AIRCRAFT)(EarliestLandingTime[i]);
int: MaxLatest   = max(i in AIRCRAFT)(LatestLandingTime[i]);

% Variables
% Actual landing time for each aircraft (bounded by overall min/max to help propagation)
array[AIRCRAFT] of var MinEarliest..MaxLatest: LandingTime;

% Amount of time aircraft lands before/after target (nonnegative)
array[AIRCRAFT] of var 0..MaxLatest: Early;
array[AIRCRAFT] of var 0..MaxLatest: Late;

% LandBefore[i,j] = true iff i lands before j (for i != j)
array[AIRCRAFT, AIRCRAFT] of var bool: LandBefore;

% Total weighted earliness/tardiness penalty
var int: TotalPenalty;

% Constraints
%--------------------------
% Time window constraints
%--------------------------
constraint forall(i in AIRCRAFT) (
  LandingTime[i] >= EarliestLandingTime[i] /\
  LandingTime[i] <= LatestLandingTime[i]
);

% Early/Late bounds consistent with windows and target
constraint forall(i in AIRCRAFT) (
  Early[i] <= (TargetLandingTime[i] - EarliestLandingTime[i]) /\
  Late[i]  <= (LatestLandingTime[i] - TargetLandingTime[i])
);

% Define early/late relative to target:
% LandingTime = Target - Early + Late, with Early and Late >= 0
constraint forall(i in AIRCRAFT) (
  LandingTime[i] = TargetLandingTime[i] - Early[i] + Late[i]
);

% Total penalty definition
constraint TotalPenalty =
  sum(i in AIRCRAFT)(
    PenaltyTimeBeforeTarget[i] * Early[i] +
    PenaltyTimeAfterTarget[i]  * Late[i]
  );

%--------------------------
% Landing order consistency
%--------------------------
% No aircraft is before itself
constraint forall(i in AIRCRAFT) (
  LandBefore[i,i] = false
);

% For any distinct pair (i,j), exactly one precedes the other
constraint forall(i, j in AIRCRAFT where i < j) (
  LandBefore[i,j] xor LandBefore[j,i]
);

%--------------------------
% Separation / disjunctive landing constraints
%--------------------------
% If i lands before j, then j must land at least SeparationTimeMatrix[i,j] after i.
% Otherwise, i must land at least SeparationTimeMatrix[j,i] after j.
constraint forall(i, j in AIRCRAFT where i != j) (
  (LandBefore[i,j] -> LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i,j]) /\
  (not LandBefore[i,j] -> LandingTime[i] >= LandingTime[j] + SeparationTimeMatrix[j,i])
);

% Objective
solve minimize TotalPenalty;