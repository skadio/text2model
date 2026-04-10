% Parameters
include "globals.mzn";

int: n = 6;                                    % Number of cities
set of int: Cities = 1..n;                     % City indices

array[Cities, Cities] of int: cost =           % Travel cost matrix (0 on diagonal)
  [|  0, 63, 62, 49, 58, 38
   | 63,  0, 93, 21, 66, 42
   | 62, 93,  0, 26, 99, 96
   | 49, 21, 26,  0, 73, 80
   | 58, 66, 99, 73,  0, 76
   | 38, 42, 96, 80, 76,  0 |];

int: maxCost = max([cost[i,j] | i in Cities, j in Cities]);  % Upper bound on any arc cost

% Variables
array[Cities] of var Cities: succ;             % succ[i] = next city visited after i
array[Cities] of var Cities: pred;             % pred[i] = previous city visited before i
array[Cities] of var 0..(n-1): pos;            % position/order of each city in the tour
var 0..(n * maxCost): totalCost;               % total tour cost (bounded)

% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint
  circuit(succ);

% --- Link predecessor array with successor array for consistency ---
constraint
  inverse(succ, pred);

% --- Disallow self-loops explicitly (redundant with circuit, but clarifies intent) ---
constraint
  forall(i in Cities) (
    succ[i] != i /\ pred[i] != i
  );

% --- Tour ordering: positions form a permutation of 0..n-1 (unique visit order) ---
constraint
  all_different(pos);

% --- Successor implies next position in the cyclic order ---
constraint
  forall(i in Cities) (
    pos[succ[i]] = (pos[i] + 1) mod n
  );

% --- Total cost equals sum of arc costs along the successor edges ---
constraint
  totalCost = sum(i in Cities) ( cost[i, succ[i]] );

% Objective
solve minimize totalCost;