% Parameters
int: CustomerCount;
int: VehicleCount;

set of int: C = 1..CustomerCount;          % customers
set of int: V = 1..VehicleCount;          % vehicles
set of int: N = 0..CustomerCount;          % nodes incl. depot 0

array[C] of int: CustomerDemand;
array[C] of int: CustomerLBTW;
array[C] of int: CustomerUBTW;
array[C, C] of int: CustomerDistance;
array[C] of int: CustomerServiceTime;
array[V] of int: VehicleCapacity;

% Derived parameters (bounds)
int: MaxUB = max([CustomerUBTW[i] | i in C]);
int: MaxArc = max([CustomerDistance[i,j] | i in C, j in C]);
int: MaxService = max([CustomerServiceTime[i] | i in C]);
int: BigM = MaxUB + MaxArc + MaxService + 1;

% Variables
array[V, N, N] of var 0..1: x;             % x[v,i,j]=1 if vehicle v goes i->j

array[V, N] of var 0..MaxUB: t;            % arrival/start-of-service time at node i for vehicle v
array[V, N] of var 0..1: use;              % use[v,i]=1 if vehicle v visits node i (for i in C); depot handled too

var 0..(VehicleCount * CustomerCount * MaxArc): total_cost;

% Constraints
% Basic arc feasibility (no self-loops)
constraint
  forall(v in V, i in N) (
    x[v,i,i] = 0
  );

% Link use and routing (flow conservation per vehicle)
constraint
  forall(v in V, i in N) (
    use[v,i] = sum(j in N)(x[v,i,j])
  );

constraint
  forall(v in V, i in N) (
    use[v,i] = sum(j in N)(x[v,j,i])
  );

% Each customer is visited exactly once by exactly one vehicle
constraint
  forall(i in C) (
    sum(v in V)(use[v,i]) = 1
  );

% Each vehicle starts and ends at depot (single route per vehicle; can be unused only if it stays at depot and doesn't serve)
constraint
  forall(v in V) (
    sum(j in C)(x[v,0,j]) = sum(j in C)(x[v,j,0])
  );

constraint
  forall(v in V) (
    sum(j in C)(x[v,0,j]) <= 1
  );

% Capacity constraints
constraint
  forall(v in V) (
    sum(i in C)(CustomerDemand[i] * use[v,i]) <= VehicleCapacity[v]
  );

% Time window constraints (enforced only if customer is visited)
constraint
  forall(v in V, i in C) (
    t[v,i] >= CustomerLBTW[i] * use[v,i]
  );

constraint
  forall(v in V, i in C) (
    t[v,i] <= CustomerUBTW[i] + BigM * (1 - use[v,i])
  );

% Depot time fixed to 0
constraint
  forall(v in V) (
    t[v,0] = 0
  );

% Time propagation along used arcs:
% If arc i->j is used, then t[j] >= t[i] + service(i) + travel(i,j).
% For depot, service time is 0 and travel costs are not given; assume 0 to/from depot.
function int: svc(int: n) = if n=0 then 0 else CustomerServiceTime[n] endif;
function int: dist(int: a, int: b) =
  if a=0 \/ b=0 then 0 else CustomerDistance[a,b] endif;

constraint
  forall(v in V, i in N, j in N where i != j) (
    t[v,j] >= t[v,i] + svc(i) + dist(i,j) - BigM * (1 - x[v,i,j])
  );

% Disallow depot-to-depot arc (unnecessary)
constraint
  forall(v in V) (
    x[v,0,0] = 0
  );

% Objective: total transportation cost between customers (depot arcs have 0 cost as distances not provided)
constraint
  total_cost =
    sum(v in V, i in N, j in N where i != j)(
      dist(i,j) * x[v,i,j]
    );

% Objective
solve minimize total_cost;