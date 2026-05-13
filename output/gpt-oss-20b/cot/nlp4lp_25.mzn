% Parameters
int: K = length(Royalty);
int: I = length(RequiredQuality);
int: MaxWork; % from input
array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;
array[1..I] of float: RequiredQuality;
float: Price;
float: Discount;

% Variables
array[1..K, 1..I] of var bool: operate;
array[1..K, 1..I] of var bool: open;
array[1..K, 1..I] of var float: prod;

% Constraints
constraint
  % Production only when mine is open
  forall(k in 1..K, i in 1..I) (
    prod[k,i] <= Limit[k] * (open[k,i] -> 1)
  ) /\ 
  % Operate only when open
  forall(k in 1..K, i in 1..I) (
    operate[k,i] <= open[k,i]
  ) /\ 
  % Once closed, cannot reopen
  forall(k in 1..K, i in 1..I-1) (
    open[k,i] >= open[k,i+1]
  ) /\ 
  % Limit on number of mines operated per year
  forall(i in 1..I) (
    sum(k in 1..K) operate[k,i] <= MaxWork
  ) /\ 
  % Ensure some production each year
  forall(i in 1..I) (
    sum(k in 1..K) prod[k,i] >= 1e-6
  ) /\ 
  % Blended quality constraint
  forall(i in 1..I) (
    sum(k in 1..K) (Quality[k] * prod[k,i]) = RequiredQuality[i] * sum(k in 1..K) prod[k,i]
  );

% Objective
solve maximize
  sum(i in 1..I) (
    (Price * sum(k in 1..K) prod[k,i] - sum(k in 1..K) (Royalty[k] * open[k,i])) / pow(1+Discount, i-1)
  );