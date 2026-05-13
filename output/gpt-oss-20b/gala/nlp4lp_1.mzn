% ------------------------------------------------------------------
%  Production planning – maximize revenue subject to material limits
% ------------------------------------------------------------------

int: M;                     % number of goods
int: N;                     % number of raw materials

array[1..M, 1..N] of int: Requirements;  % requirements[j,i]
array[1..N] of int: Available;           % available amount of material i
array[1..M] of int: Prices;              % revenue per unit of good j

% Upper bound on production – total amount of all materials
int: maxProd = sum(Available);

array[1..M] of var 0..maxProd: produce;   % quantity of each good

% Material constraints
constraint
  forall(i in 1..N) (
    sum(j in 1..M)(produce[j] * Requirements[j,i]) <= Available[i]
  );

% Objective: maximize total revenue
solve maximize
  sum(j in 1..M)(produce[j] * Prices[j]);

% ------------------------------------------------------------------
%  Output
% ------------------------------------------------------------------
output [
  "Production plan: ", show(produce), "\n",
  "Total revenue: ", show(sum(j in 1..M)(produce[j] * Prices[j])), "\n"
];