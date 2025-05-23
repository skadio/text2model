% Number of different goods produced by the firm
int: M;

% Number of different raw materials used by the firm
int: N;

% Available amount of raw material i
array[1..N] of int: Available;

% Requirement of raw material i to produce one unit of good j
array[1..M, 1..N] of int: Requirements;

% Revenue earned from selling one unit of good j
array[1..M] of int: Prices;

% Decision variable: how much of each good to produce
array[1..M] of var 0..sum(Available): Produce;

% Objective: maximize total revenue
var int: TotalRevenue = sum(j in 1..M)(Produce[j] * Prices[j]);
maximize TotalRevenue;

% Constraints: cannot use more raw material than available
constraint forall(i in 1..N)(
  sum(j in 1..M)(Produce[j] * Requirements[j, i]) <= Available[i]
);

solve satisfy;
output [ "Total Revenue: " ++ show(TotalRevenue) ++ "\n" ] ++
[ if fix(Produce[j]) > 0 then "Produce " ++ show(j) ++ ": " ++ show(Produce[j]) ++ "\n" else "" endif | j in 1..M ];