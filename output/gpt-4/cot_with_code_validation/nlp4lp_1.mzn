% Parameters
int: M; % Number of different goods produced by the firm
int: N; % Number of different raw materials used by the firm
array[1..N] of int: Available; % Available amount of raw material i
array[1..M, 1..N] of int: Requirements; % Requirement of raw material i to produce one unit of good j
array[1..M] of int: Prices; % Revenue earned from selling one unit of good j

% Variables
array[1..M] of var 0..max(Available): Goods; % Amount of each good to be produced

% Constraints
constraint forall(i in 1..N)(
  sum(j in 1..M)(Requirements[j, i] * Goods[j]) <= Available[i]
);

% Objective
var int: TotalRevenue = sum(j in 1..M)(Prices[j] * Goods[j]);
solve maximize TotalRevenue;