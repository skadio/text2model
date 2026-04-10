% Mining planning with blending-quality constraints

% --------------------------
% Parameters (from data.dzn)
% --------------------------
int: K;                          % number of mines
int: MaxWork;                    % max mines that can be operated in a year

array[1..K] of float: Royalty;   % yearly royalty if mine is kept open
array[1..K] of float: Limit;     % yearly production limit
array[1..K] of float: Quality;   % ore quality from each mine

int: I;                                  % number of years
array[1..I] of float: RequiredQuality;   % required blended quality each year

float: Price;                    % selling price per ton
float: Discount;                 % discount rate per annum

% --------------------------
% Decision variables
% --------------------------
array[1..I, 1..K] of var float: x;        % production from mine k in year i
array[1..I, 1..K] of var bool: work;      % mine k operated in year i
array[1..I, 1..K] of var bool: open;      % mine k kept open in year i (royalty paid)

array[1..I] of var float: totalProd;      % total blended production in year i
var float: profit;

% --------------------------
% Constraints
% --------------------------
constraint forall(i in 1..I, k in 1..K) (
  x[i,k] >= 0.0
);

% Production only if worked, and within limit
constraint forall(i in 1..I, k in 1..K) (
  x[i,k] <= Limit[k] * bool2int(work[i,k])
);

% At most MaxWork mines worked each year
constraint forall(i in 1..I) (
  sum(k in 1..K)(bool2int(work[i,k])) <= MaxWork
);

% If a mine is worked, it must be open that year
constraint forall(i in 1..I, k in 1..K) (
  bool2int(open[i,k]) >= bool2int(work[i,k])
);

% Once closed, cannot reopen (open is non-increasing over time)
constraint forall(i in 1..I-1, k in 1..K) (
  bool2int(open[i+1,k]) <= bool2int(open[i,k])
);

% Total production per year
constraint forall(i in 1..I) (
  totalProd[i] = sum(k in 1..K)(x[i,k])
);

% Exact blended quality each year:
% sum_k x[i,k] * Quality[k] = RequiredQuality[i] * sum_k x[i,k]
constraint forall(i in 1..I) (
  sum(k in 1..K)(x[i,k] * Quality[k]) = RequiredQuality[i] * totalProd[i]
);

% --------------------------
% Objective: discounted profit
% --------------------------
constraint profit =
  sum(i in 1..I)(
    let { float: disc = 1.0 / pow(1.0 + Discount, i - 1) } in
      disc * (
        Price * totalProd[i]
        - sum(k in 1..K)(Royalty[k] * bool2int(open[i,k]))
      )
  );

solve maximize profit;