% Parameters
int: K;
set of int: YEAR = 1..K;
set of int: IND  = 1..K;

array[IND, IND] of float: InputOne;
array[IND, IND] of float: InputTwo;

array[IND] of float: ManpowerOne;
array[IND] of float: ManpowerTwo;

array[IND] of float: Stock;
array[IND] of float: Capacity;

float: ManpowerLimit;

% Derived set for the last two years
set of int: LAST_TWO = { t | t in YEAR where t >= max(1, K - 1) };

% Decision variables
array[YEAR, IND] of var float: prod;

% Constraints
constraint
  forall(t in YEAR, k in IND) (
    prod[t, k] >= 0.0 /\ prod[t, k] <= Capacity[k]
  );

constraint
  forall(t in YEAR) (
    sum(k in IND)(
      (ManpowerOne[k] + ManpowerTwo[k]) * prod[t, k]
    ) <= ManpowerLimit
  );

% Objective
solve maximize
  sum(t in LAST_TWO, k in IND)( prod[t, k] );