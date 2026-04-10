% Parameters
int: TotalAircrafts;
set of int: A = 1..TotalAircrafts;

array[A] of int: EarliestLandingTime;
array[A] of int: LatestLandingTime;
array[A] of int: TargetLandingTime;
array[A] of int: PenaltyTimeAfterTarget;
array[A] of int: PenaltyTimeBeforeTarget;

array[A, A] of int: SeparationTimeMatrix;

% Variables
int: minT = min([EarliestLandingTime[i] | i in A]);
int: maxT = max([LatestLandingTime[i] | i in A]);

array[A] of var minT..maxT: LandingTime;

array[A] of var 0..(maxT - minT): Early;
array[A] of var 0..(maxT - minT): Late;

% Precedence decision between each pair (i<j):
% Before[i,j]=true means i lands before j, else j lands before i.
array[A, A] of var bool: Before;

var int: TotalPenalty;

% Constraints
constraint
  forall(i in A) (
    EarliestLandingTime[i] <= LandingTime[i] /\
    LandingTime[i] <= LatestLandingTime[i]
  );

constraint
  forall(i in A) (
    Early[i] >= TargetLandingTime[i] - LandingTime[i] /\
    Late[i]  >= LandingTime[i] - TargetLandingTime[i]
  );

constraint
  forall(i in A) (
    LandingTime[i] + Early[i] - Late[i] = TargetLandingTime[i]
  );

constraint
  forall(i, j in A where i != j) (
    Before[i,j] <-> not Before[j,i]
  );

constraint
  forall(i in A) (
    Before[i,i] = false
  );

constraint
  forall(i, j in A where i < j) (
    (Before[i,j] -> LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i,j]) /\
    (not Before[i,j] -> LandingTime[i] >= LandingTime[j] + SeparationTimeMatrix[j,i])
  );

constraint
  TotalPenalty =
    sum(i in A)(
      PenaltyTimeBeforeTarget[i] * Early[i] +
      PenaltyTimeAfterTarget[i]  * Late[i]
    );

% Objective
solve minimize TotalPenalty;