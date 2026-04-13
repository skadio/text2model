% Parameters
include "globals.mzn";

set of int: Cities = 1..5;                 % 1=E, 2=F, 3=G, 4=H, 5=I
array[Cities, Cities] of int: cost =       % travel cost matrix (0 on diagonal)
  [|  0, 37, 72, 66, 33
   | 37,  0, 26, 56,100
   | 72, 26,  0, 49, 32
   | 66, 56, 49,  0, 13
   | 33,100, 32, 13,  0 |];

int: n = card(Cities);                     % number of cities (5)

% Variables
array[Cities] of var Cities: succ;         % succ[i] = next city visited after i
array[Cities] of var 1..n: pos;            % position of each city in the tour (for subtour elimination)
var 0..sum(i in Cities, j in Cities)(cost[i,j]): total_cost;  % objective value (bounded)

% Constraints

% --- Hamiltonian cycle structure: each city has exactly one successor and one predecessor ---
constraint
  all_different(succ);   % unique successors => each city has exactly one predecessor too

% --- Subtour elimination / single tour enforcement using positions ---
% Fix a reference city (city 1 = E) to break symmetry and anchor the tour positions
constraint
  pos[1] = 1;

% Each city has a unique position in the tour
constraint
  all_different(pos);

% Link successors to positions: for all cities except the fixed anchor,
% the successor must have the next position
constraint
  forall(i in Cities where i != 1) (
    pos[succ[i]] = pos[i] + 1
  );

% Ensure the last position city returns to the anchor city (wrap-around)
constraint
  forall(i in Cities) (
    (pos[i] = n) -> (succ[i] = 1)
  );

% --- Total cost accumulation for the chosen successors ---
constraint
  total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;