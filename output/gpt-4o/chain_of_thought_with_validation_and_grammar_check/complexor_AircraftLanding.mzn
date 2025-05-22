% Parameters
int: TotalAircrafts;
set of int: Aircrafts = 1..TotalAircrafts;

array[Aircrafts] of int: EarliestLandingTime;
array[Aircrafts] of int: LatestLandingTime;
array[Aircrafts] of int: TargetLandingTime;

array[Aircrafts] of int: PenaltyTimeAfterTarget;
array[Aircrafts] of int: PenaltyTimeBeforeTarget;

array[Aircrafts, Aircrafts] of int: SeparationTimeMatrix;

int: MIN_TIME = min(EarliestLandingTime);
int: MAX_TIME = max(LatestLandingTime);

% Variables
array[Aircrafts] of var MIN_TIME..MAX_TIME: LandingTime;

array[Aircrafts] of var bool: IsLate;

array[Aircrafts] of var 0..MAX_TIME - MIN_TIME: EarlyTime;   % time units the aircraft lands before target
array[Aircrafts] of var 0..MAX_TIME - MIN_TIME: LateTime;    % time units the aircraft lands after  target

array[Aircrafts, Aircrafts] of var bool: Before;             % Before[i,j] = true  -> i lands before j

% Constraints

% 1. Individual landing windows
constraint
  forall(i in Aircrafts) (
    EarliestLandingTime[i] <= LandingTime[i] /\
    LandingTime[i]        <= LatestLandingTime[i]
  );

% 2. Precedence variables basics
constraint
  forall(i in Aircrafts) (
    Before[i,i] = false      % an aircraft cannot precede itself
  );

constraint
  forall(i, j in Aircrafts where i < j) (
    Before[i,j] = not Before[j,i]   % antisymmetry & completeness for each pair
  );

% 3. Separation requirements
constraint
  forall(i, j in Aircrafts where i != j) (
    Before[i,j] -> LandingTime[i] + SeparationTimeMatrix[i,j] <= LandingTime[j]
  );

% 4. Early/Late time and status determination
constraint
  forall(i in Aircrafts) (
        ( IsLate[i] /\ LandingTime[i] >= TargetLandingTime[i] /\
          LateTime[i]  = LandingTime[i] - TargetLandingTime[i] /\
          EarlyTime[i] = 0 )
    \/
        ( not IsLate[i] /\ LandingTime[i] <= TargetLandingTime[i] /\
          EarlyTime[i] = TargetLandingTime[i] - LandingTime[i] /\
          LateTime[i]  = 0 )
  );

% Objective
var int: TotalPenalty =
  sum(i in Aircrafts)(
        PenaltyTimeAfterTarget[i]  * LateTime[i] +
        PenaltyTimeBeforeTarget[i] * EarlyTime[i]
  );

solve minimize TotalPenalty;