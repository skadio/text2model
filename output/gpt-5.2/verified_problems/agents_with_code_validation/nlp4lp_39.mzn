% Alloy blending / least-cost formulation (LP)

% Parameters
int: K;                              % number of available source alloys
int: M;                              % number of metals/components
int: AlloyQuantity;                  % total quantity (lb) of final alloy to produce

array[1..M] of float: Target;        % target quantity (lb) of each metal in final alloy
array[1..K, 1..M] of float: Ratio;   % ratio (fraction by weight) of metal m in alloy k
array[1..K] of float: Price;         % price per lb (or per unit) of alloy k

% Variables
array[1..K] of var float: x;         % amount (lb) of each source alloy k to use
var float: total_cost;               % total cost

% Bounds (kept separate to avoid float domain issues)
constraint forall(k in 1..K)(x[k] >= 0.0 /\ x[k] <= float(AlloyQuantity));
constraint total_cost >= 0.0;

% Total quantity constraint
constraint sum(k in 1..K)(x[k]) = float(AlloyQuantity);

% Metal composition constraints
constraint
  forall(m in 1..M)(
    sum(k in 1..K)(x[k] * Ratio[k,m]) = Target[m]
  );

% Total cost definition
constraint total_cost = sum(k in 1..K)(x[k] * Price[k]);

solve :: lp minimize total_cost;