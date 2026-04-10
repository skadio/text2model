include "globals.mzn";

% Parameters
int: R = 1850;                        % raw pipe length (mm)
int: K = 4;                           % number of order item types
set of int: T = 1..K;

array[T] of int: L = [290, 315, 350, 455];   % piece lengths (mm)
array[T] of int: D = [15, 28, 21, 30];       % demands

int: P = 4;                           % max number of patterns allowed
set of int: Pat = 1..P;

int: maxPiecesPerPipe = 5;
int: maxWaste = 100;

% extra cost fractions by rank (most used pattern gets 1/10, 2nd 2/10, ...)
array[Pat] of int: rankCostNum = [1, 2, 3, 4];
int: rankCostDen = 10;

% upper bound on number of pipes needed
int: U = sum(t in T)(D[t]);
set of int: Pipes = 0..U;

% Variables
array[Pat, T] of var 0..maxPiecesPerPipe: a;   % pattern composition
array[Pat] of var Pipes: x;                    % number of pipes for each pattern

array[Pat] of var 0..maxWaste: waste;
array[Pat] of var 0..maxPiecesPerPipe: pieces;

% ranking permutation: invpos[r] is pattern at rank r (1=most used)
array[Pat] of var Pat: invpos;

% sorted usage counts by rank
array[Pat] of var Pipes: y;

% linearization of cost term: z[r] = y[r] * rankCostNum[r]
array[Pat] of var 0..(U * max(rankCostNum)): z;

% total cost scaled by 10: 10*(#pipes) + sum_r rankCostNum[r]*y[r]
var 0..(10*U + U*sum(r in Pat)(rankCostNum[r])): totalCost10;

% Constraints
% Define pieces and waste for each pattern, with feasibility (waste <= 100) and <=5 pieces
constraint
  forall(p in Pat) (
    pieces[p] = sum(t in T)(a[p,t]) /\
    pieces[p] <= maxPiecesPerPipe /\
    sum(t in T)(L[t] * a[p,t]) + waste[p] = R /\
    waste[p] <= maxWaste
  );

% Meet demands exactly
constraint
  forall(t in T) (
    sum(p in Pat)(a[p,t] * x[p]) = D[t]
  );

% Ranking: invpos is a permutation of patterns
constraint all_different(invpos);

% Link sorted usages y to x via invpos, and enforce non-increasing order
constraint forall(r in Pat)( y[r] = x[invpos[r]] );
constraint forall(r in 1..P-1)( y[r] >= y[r+1] );

% Compute extra cost terms
constraint forall(r in Pat)( z[r] = y[r] * rankCostNum[r] );

% Total cost (scaled by 10)
constraint
  totalCost10 = 10 * sum(p in Pat)(x[p]) + sum(r in Pat)(z[r]);

solve minimize totalCost10;

output [
  "totalCost10 = ", show(totalCost10), " (i.e., ", show(totalCost10), "/10 raw-pipe-units)\n",
  "x = ", show(x), "\n",
  "patterns a[p,t] (p rows, t columns):\n",
  concat([ "p" ++ show(p) ++ ": " ++ show([a[p,t] | t in T]) ++ " waste=" ++ show(waste[p]) ++ "\n" | p in Pat ]),
  "invpos = ", show(invpos), "\n",
  "y(sorted usages) = ", show(y), "\n"
];