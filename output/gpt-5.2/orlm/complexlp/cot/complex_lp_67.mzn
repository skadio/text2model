% Parameters (with values embedded)
int: N = 5;
set of int: W = 1..N; % 1=A, 2=B, 3=C, 4=D, 5=E

array[W, W] of int: cost =
  [| 0, 15, 88, 54, 92
   | 15, 0, 29, 98, 33
   | 88, 29, 0, 96, 96
   | 54, 98, 96, 0, 63
   | 92, 33, 96, 63, 0 |];

% Variables
array[W] of var W: succ;            % successor city in the tour
array[W] of var 0..N-1: pos;        % position/order for subtour elimination (MTZ)

% Constraints
constraint forall(i in W)(succ[i] != i);          % no self loops
constraint all_different(succ);                   % each node has exactly one outgoing and one incoming

% MTZ subtour elimination (fix a reference node)
constraint pos[1] = 0;
constraint forall(i in 2..N)(pos[i] >= 1 /\ pos[i] <= N-1);
constraint forall(i, j in 2..N where i != j)(
  pos[i] - pos[j] + (N-1) * bool2int(succ[i] == j) <= N-2
);

% Objective
var int: total_cost = sum(i in W)(cost[i, succ[i]]);
solve minimize total_cost;