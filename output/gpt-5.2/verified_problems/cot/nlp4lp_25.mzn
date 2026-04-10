% Parameters
int: K;
int: MaxWork;
array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

int: I;
array[1..I] of float: RequiredQuality;

float: Price;
float: Discount;

% Variables
array[1..I, 1..K] of var float: x;          % production from mine k in year i
array[1..I, 1..K] of var bool: work;        % whether mine k is operated in year i

array[1..I, 1..K] of var bool: open;        % whether mine k is kept open in year i
array[1..I, 1..K] of var bool: close;       % whether mine k is permanently closed at end of year i

% Constraints
constraint forall(i in 1..I, k in 1..K) (
  x[i,k] >= 0.0
);

constraint forall(i in 1..I, k in 1..K) (
  x[i,k] <= Limit[k] * bool2int(work[i,k])
);

constraint forall(i in 1..I) (
  sum(k in 1..K)(bool2int(work[i,k])) <= MaxWork
);

% Open/close logic: once closed, cannot be reopened; working implies open
constraint forall(k in 1..K) (
  open[1,k] = true
);

constraint forall(i in 1..I, k in 1..K) (
  bool2int(work[i,k]) <= bool2int(open[i,k])
);

constraint forall(i in 1..I-1, k in 1..K) (
  bool2int(open[i+1,k]) = bool2int(open[i,k]) - bool2int(close[i,k])
);

constraint forall(i in 1..I, k in 1..K) (
  bool2int(close[i,k]) <= bool2int(open[i,k])
);

% If mine is open but not worked, royalties are still paid (captured in objective via open)
% Blended quality must equal RequiredQuality[i] each year:
% sum_k (Quality[k] * x[i,k]) = RequiredQuality[i] * sum_k x[i,k]
constraint forall(i in 1..I) (
  sum(k in 1..K)(Quality[k] * x[i,k]) = RequiredQuality[i] * sum(k in 1..K)(x[i,k])
);

% Objective
% Discount factor for year i (year 1 undiscounted): 1/(1+Discount)^(i-1)
var float: profit =
  sum(i in 1..I)(
    let { float: df = 1.0 / pow(1.0 + Discount, i-1) } in
      df * (
        Price * sum(k in 1..K)(x[i,k])
        - sum(k in 1..K)(Royalty[k] * bool2int(open[i,k]))
      )
  );

solve maximize profit;