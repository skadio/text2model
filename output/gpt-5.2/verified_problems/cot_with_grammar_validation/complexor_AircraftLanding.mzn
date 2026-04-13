% Parameters
int: TotalAircrafts;

set of int: A = 1..TotalAircrafts;

array[A] of int: EarliestLandingTime;
array[A] of int: LatestLandingTime;
array[A] of int: TargetLandingTime;
array[A] of int: PenaltyTimeAfterTarget;
array[A] of int: PenaltyTimeBeforeTarget;

array[A, A] of int: SeparationTimeMatrix;

int: MinTime = min(EarliestLandingTime);
int: MaxTime = max(LatestLandingTime);
int: MaxSpan = MaxTime - MinTime;

% Variables
array[A] of var MinTime..MaxTime: LandingTime;

array[A] of var 0..MaxSpan: Early;
array[A] of var 0..MaxSpan: Late;

% Order[i,j] = 1 if i lands before j, else 0 (for i != j)
array[A, A] of var 0..1: Order;

% Constraints
constraint forall(i in A) (
  EarliestLandingTime[i] <= LandingTime[i] /\
  LandingTime[i] <= LatestLandingTime[i]
);

constraint forall(i in A) (
  LandingTime[i] + Early[i] - Late[i] = TargetLandingTime[i]
);

constraint forall(i in A, j in A where i != j) (
  Order[i,j] + Order[j,i] = 1
);

constraint forall(i in A) ( Order[i,i] = 0 );

constraint forall(i in A, j in A where i != j) (
  LandingTime[j] - LandingTime[i] >= SeparationTimeMatrix[i,j] - (1 - Order[i,j]) * MaxSpan
);

% Objective
var int: TotalPenalty =
  sum(i in A) (
    PenaltyTimeBeforeTarget[i] * Early[i] +
    PenaltyTimeAfterTarget[i] * Late[i]
  );

solve minimize TotalPenalty;