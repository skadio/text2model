% Parameters
int: M; % Number of different goods produced by the firm
int: N; % Number of different raw materials used by the firm
array[1..N] of int: Available; % Available amount of each raw material
array[1..N, 1..M] of int: Requirements; % Requirement of each raw material to produce one unit of each good
array[1..M] of int: Prices; % Revenue earned from selling one unit of each good

% Variables
array[1..M] of var 0..max(Available): GoodsProduced; % Amount of each good to be produced

% Constraints

% The total amount of each raw material used should not exceed the available amount
constraint forall(i in 1..N) (
  sum(j in 1..M) (Requirements[i,j] * GoodsProduced[j]) <= Available[i]
);

% The amount of each good produced should be non-negative
constraint forall(j in 1..M) (
  GoodsProduced[j] >= 0
);

% Objective

% The firm should maximize its total revenue
solve maximize sum(j in 1..M) (Prices[j] * GoodsProduced[j]);