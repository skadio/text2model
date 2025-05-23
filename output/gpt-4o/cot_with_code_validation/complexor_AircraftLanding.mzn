% Parameters
int: TotalAircrafts;

set of int: AIRCRAFT = 1..TotalAircrafts;

array[AIRCRAFT] of int: EarliestLandingTime;
array[AIRCRAFT] of int: LatestLandingTime;
array[AIRCRAFT] of int: TargetLandingTime;
array[AIRCRAFT] of int: PenaltyTimeAfterTarget;
array[AIRCRAFT] of int: PenaltyTimeBeforeTarget;
array[AIRCRAFT, AIRCRAFT] of int: SeparationTimeMatrix;

% Variables
array[AIRCRAFT] of var int: LandingTime;     % actual landing times
array[AIRCRAFT] of var int: Early;           % minutes landed before target
array[AIRCRAFT] of var int: Late;            % minutes landed after target

array[AIRCRAFT, AIRCRAFT] of var bool: Before;  % Before[i,j] = true  -> i lands before j

var int: TotalPenalty;                       % objective value

% Pre-computed bounds for Early and Late
array[AIRCRAFT] of int: EarlyMax = [max(0, TargetLandingTime[i] - EarliestLandingTime[i]) | i in AIRCRAFT];
array[AIRCRAFT] of int: LateMax  = [max(0, LatestLandingTime[i]  - TargetLandingTime[i]) | i in AIRCRAFT];

% Constraints
% 1. Time window for every aircraft
constraint
  forall(i in AIRCRAFT)(
    EarliestLandingTime[i] <= LandingTime[i] /\
    LandingTime[i] <= LatestLandingTime[i]
  );

% 2. Relation between landing time and earliness / lateness
constraint
  forall(i in AIRCRAFT)(
    LandingTime[i] = TargetLandingTime[i] - Early[i] + Late[i]
  );

% 3. Bounds for Early and Late
constraint
  forall(i in AIRCRAFT)(
    0 <= Early[i] /\ Early[i] <= EarlyMax[i] /\
    0 <= Late[i]  /\ Late[i]  <= LateMax[i]
  );

% 4. Exactly one order between any two different aircraft
constraint
  forall(i, j in AIRCRAFT where i != j)(
    Before[i,j] <-> not Before[j,i]
  ) /\
  forall(i in AIRCRAFT)(
    Before[i,i] = false
  );

% 5. Separation constraints
constraint
  forall(i, j in AIRCRAFT where i < j)(
      ( Before[i,j] ->
          LandingTime[j] - LandingTime[i] >= SeparationTimeMatrix[i,j] )
   /\ ( not Before[i,j] ->
          LandingTime[i] - LandingTime[j] >= SeparationTimeMatrix[j,i] )
  );

% Objective: minimize total penalty
constraint
  TotalPenalty = sum(i in AIRCRAFT)(
                    PenaltyTimeBeforeTarget[i] * Early[i] +
                    PenaltyTimeAfterTarget[i]  * Late[i]
                 );

solve minimize TotalPenalty;