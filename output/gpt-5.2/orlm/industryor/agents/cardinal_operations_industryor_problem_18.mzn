% Parameters

% Manufacturers (indexed as 1=A, 2=B, 3=C)
set of int: M = 1..3;
int: A = 1;
int: B = 2;
int: C = 3;

% Cost per chair by manufacturer
array[M] of int: cost_per_chair = [50, 45, 40];

% Chairs per order by manufacturer
array[M] of int: chairs_per_order = [15, 10, 10];

% Total chairs requirements
int: min_total_chairs = 100;
int: max_total_chairs = 500;

% Implication requirements (in chairs)
int: min_B_chairs_if_A_used = 10;


% Variables

% Number of orders placed with each manufacturer (integer, non-negative)
array[M] of var int: orders;

% Total number of chairs ordered from each manufacturer
array[M] of var int: chairs;

% Total number of chairs ordered overall
var int: total_chairs;

% Binary indicators: whether a manufacturer is used (has at least 1 order)
array[M] of var 0..1: used;


% Constraints

% --- Link orders, chairs, and usage indicators ---
constraint forall(m in M) (
  orders[m] >= 0
);

constraint forall(m in M) (
  chairs[m] = orders[m] * chairs_per_order[m]
);

constraint forall(m in M) (
  used[m] <-> (orders[m] >= 1)
);

% --- Total chairs aggregation and bounds ---
constraint total_chairs = sum(m in M)(chairs[m]);
constraint total_chairs >= min_total_chairs;
constraint total_chairs <= max_total_chairs;

% --- Conditional sourcing requirements ---
% If A is used, must order at least 10 chairs from B
constraint used[A] -> (chairs[B] >= min_B_chairs_if_A_used);

% If B is used, must also order from C (at least one order)
constraint used[B] -> used[C];


% Objective
solve minimize sum(m in M)(chairs[m] * cost_per_chair[m]);