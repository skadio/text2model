% Parameters
int: G = 3;
int: N = 4;

set of int: Grains = 1..G;
set of int: Nutrients = 1..N;

% nutrient content per pound of grain (scaled by 10 to avoid decimals)
% order of nutrients: A=1, B=2, C=3, D=4
array[Nutrients, Grains] of int: content10 =
 [| 200, 300, 700   % A
  | 100, 100,   0   % B
  | 500, 300,   0   % C
  |  60,  25, 100   % D
  |];

% minimum daily requirements (scaled by 10)
array[Nutrients] of int: minreq10 = [1100, 180, 900, 140];

% costs in cents per pound (scaled by 10)
array[Grains] of int: cost10 = [410, 360, 960];

% bound on pounds (scaled by 10): derived from requirements and positive contents
% max needed for any nutrient using only one grain <= max_j (minreq10[j]/min_positive_content10[j])*10
int: XMAX10 = 1100;

% Variables
array[Grains] of var 0..XMAX10: x10;   % pounds of each grain, scaled by 10
var 0..(sum(g in Grains)(cost10[g]*XMAX10)): totalCost100; % total cost in cents*100

% Constraints
constraint
  forall(n in Nutrients)(
    sum(g in Grains)(content10[n,g] * x10[g]) >= minreq10[n] * 10
  );

constraint
  totalCost100 = sum(g in Grains)(cost10[g] * x10[g]);

% Objective
solve minimize totalCost100;