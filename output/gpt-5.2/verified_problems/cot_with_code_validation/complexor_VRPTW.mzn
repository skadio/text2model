%----------------------------
% VRPTW (single depot) model
%----------------------------

% Parameters
int: CustomerCount;
int: VehicleCount;

set of int: C = 1..CustomerCount;
set of int: V = 1..VehicleCount;
set of int: N = 0..CustomerCount; % 0 is depot

array[C] of int: CustomerDemand;
array[C] of int: CustomerLBTW;
array[C] of int: CustomerUBTW;
array[C, C] of int: CustomerDistance;
array[C] of int: CustomerServiceTime;
array[V] of int: VehicleCapacity;

% Big-M for time feasibility (conservative)
int: MTime =
  max([CustomerUBTW[i] | i in C])
  + sum([CustomerServiceTime[i] | i in C])
  + max([CustomerDistance[i,j] | i in C, j in C]);

% Distance including depot (no depot distances provided -> assume 0)
function int: dist(int: i, int: j) =
  if (i == 0) \/ (j == 0) then 0 else CustomerDistance[i,j] endif;

function int: service(int: i) =
  if i == 0 then 0 else CustomerServiceTime[i] endif;

function int: demand(int: i) =
  if i == 0 then 0 else CustomerDemand[i] endif;

function int: twL(int: i) =
  if i == 0 then 0 else CustomerLBTW[i] endif;

function int: twU(int: i) =
  if i == 0 then MTime else CustomerUBTW[i] endif;

% Variables
array[V, N, N] of var 0..1: x;           % x[v,i,j] = 1 if vehicle v travels i -> j
array[V, N] of var 0..MTime: t;          % time at node i for vehicle v
array[V] of var 0..sum(CustomerDemand): load;

% Constraints

% No self-loops
constraint forall(v in V, i in N) ( x[v,i,i] = 0 );

% Each customer visited exactly once: one incoming and one outgoing overall
constraint forall(c in C)(
  sum(v in V, i in N)(x[v,i,c]) = 1
);
constraint forall(c in C)(
  sum(v in V, j in N)(x[v,c,j]) = 1
);

% Each vehicle starts and ends at depot (can be unused)
constraint forall(v in V)(
  sum(j in C)(x[v,0,j]) = sum(i in C)(x[v,i,0])
);
constraint forall(v in V)(
  sum(j in C)(x[v,0,j]) <= 1
);

% Flow conservation per vehicle at each customer
constraint forall(v in V, c in C)(
  sum(i in N)(x[v,i,c]) = sum(j in N)(x[v,c,j])
);

% Time windows, conditional on visit
constraint
  forall(v in V, c in C)(
    let { var 0..1: visit = sum(i in N)(x[v,i,c]) } in
      t[v,c] >= twL(c) * visit /\
      t[v,c] <= twU(c) + MTime * (1 - visit)
  );

% Time propagation along used arcs
constraint
  forall(v in V, i in N, j in N where i != j)(
    t[v,j] >= t[v,i] + service(i) + dist(i,j) - MTime * (1 - x[v,i,j])
  );

% Vehicle capacity
constraint forall(v in V)(
  load[v] = sum(i in C, j in N)( demand(i) * x[v,i,j] )
);
constraint forall(v in V)(
  load[v] <= VehicleCapacity[v]
);

% Objective: minimize total travel cost
var int: TotalCost = sum(v in V, i in N, j in N)( dist(i,j) * x[v,i,j] );

solve minimize TotalCost;