% Parameters
int: K;
int: MaxWork;
array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;
array[int] of float: RequiredQuality;
float: Price;
float: Discount;

% Derived sets and constants
set of int: Years = index_set(RequiredQuality);
int: Y_last = max(Years);
float: MaxLimit = max([Limit[k] | k in 1..K]);

% Decision variables
array[1..K, Years] of var bool: operate;
array[1..K, Years] of var bool: open;
array[1..K, Years] of var 0.0..MaxLimit: Prod;

% A mine must be open if it is operated
constraint
  forall(k in 1..K, y in Years)(
    operate[k,y] -> open[k,y]
  );

% A mine cannot re-open once it has been closed
constraint
  forall(k in 1..K, y in Years where y < Y_last)(
    open[k,y+1] -> open[k,y]
  );

% Production bounds
constraint
  forall(k in 1..K, y in Years)(
    Prod[k,y] <= Limit[k] * bool2int(operate[k,y])
  );

% Maximum number of operating mines per year
constraint
  forall(y in Years)(
    sum(k in 1..K)(bool2int(operate[k,y])) <= MaxWork
  );

% Blended quality requirement per year
constraint
  forall(y in Years)(
    sum(k in 1..K)(Prod[k,y] * Quality[k]) =
    RequiredQuality[y] * sum(k in 1..K)(Prod[k,y])
  );

% Net present value
var float: NPV =
  sum(y in Years)(
    (Price * sum(k in 1..K)(Prod[k,y])
     - sum(k in 1..K)(Royalty[k] * bool2int(open[k,y])))
    / pow(1.0 + Discount, y - min(Years))
  );

solve maximize NPV;