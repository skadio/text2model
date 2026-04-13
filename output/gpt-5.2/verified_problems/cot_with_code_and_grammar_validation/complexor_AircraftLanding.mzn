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
int: minEarliest = min(i in A)(EarliestLandingTime[i]);
int: maxLatest   = max(i in A)(LatestLandingTime[i]);

array[A] of var minEarliest..maxLatest: LandingTime;

array[A, A] of var bool: Before; % Before[i,j] = true iff i lands before j (for i!=j)

array[A] of var 0..(maxLatest - minEarliest): Early;
array[A] of var 0..(maxLatest - minEarliest): Late;

array[A] of var 0..(maxLatest - minEarliest) * max(i in A)(max(PenaltyTimeAfterTarget[i], PenaltyTimeBeforeTarget[i])): Penalty;

var 0..sum(i in A)(
  (maxLatest - minEarliest) * max(PenaltyTimeAfterTarget[i], PenaltyTimeBeforeTarget[i])
): TotalPenalty;

% Constraints
constraint
  forall(i in A) (
    LandingTime[i] >= EarliestLandingTime[i] /\
    LandingTime[i] <= LatestLandingTime[i]
  );

constraint
  forall(i in A) (
    Early[i] >= TargetLandingTime[i] - LandingTime[i] /\
    Late[i]  >= LandingTime[i] - TargetLandingTime[i] /\
    Early[i] >= 0 /\
    Late[i]  >= 0 /\
    (Early[i] = 0 \/ Late[i] = 0)
  );

constraint
  forall(i in A) (
    Penalty[i] = PenaltyTimeBeforeTarget[i] * Early[i] + PenaltyTimeAfterTarget[i] * Late[i]
  );

constraint
  TotalPenalty = sum(i in A)(Penalty[i]);

constraint
  forall(i, j in A where i < j) (
    Before[i,j] + Before[j,i] = 1
  );

constraint
  forall(i in A) (
    Before[i,i] = false
  );

constraint
  forall(i, j in A where i != j) (
    (Before[i,j] -> LandingTime[j] >= LandingTime[i] + SeparationTimeMatrix[i,j])
  );

% Objective
solve minimize TotalPenalty;