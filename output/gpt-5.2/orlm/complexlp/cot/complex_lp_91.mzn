% Parameters (with values embedded)
int: N = 5;
set of int: Cities = 1..N; % 1=A, 2=B, 3=C, 4=D, 5=E

array[Cities, Cities] of int: cost =
  [|   0,  95,  36,  93,  16
   |  95,   0,  95,  29,  96
   |  36,  95,   0,  72,  38
   |  93,  29,  72,   0,  77
   |  16,  96,  38,  77,   0 |];

% Variables
array[Cities] of var Cities: succ;     % successor city in the tour
array[Cities] of var Cities: pred;     % predecessor city in the tour
array[Cities] of var 0..N-1: pos;      % position/order for subtour elimination

var 0..100000: total_cost;

% Constraints
constraint circuit(succ);  % enforces one Hamiltonian cycle (each city visited exactly once)
constraint inverse(succ, pred);

constraint pos[1] = 0;
constraint forall(i in Cities where i != 1) (pos[i] >= 1 /\ pos[i] <= N-1);

% Miller-Tucker-Zemlin subtour elimination (anchored at city 1)
constraint forall(i in Cities where i != 1) (
  forall(j in Cities where j != 1 /\ j != i) (
    pos[i] - pos[j] + (N-1) * bool2int(succ[i] = j) <= N-2
  )
);

constraint total_cost = sum(i in Cities)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;