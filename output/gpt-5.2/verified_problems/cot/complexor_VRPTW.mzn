% Parameters
int: CustomerCount;
int: VehicleCount;

set of int: C = 1..CustomerCount;
set of int: V = 1..VehicleCount;

array[C] of int: CustomerDemand;
array[C] of int: CustomerLBTW;
array[C] of int: CustomerUBTW;
array[C,C] of int: CustomerDistance;
array[C] of int: CustomerServiceTime;
array[V] of int: VehicleCapacity;

int: BigM = max(c in C)(CustomerUBTW[c]) + max(c in C)(CustomerServiceTime[c]) + max(i in C, j in C)(CustomerDistance[i,j]);

% Variables
array[V,C,C] of var 0..1: x;                 % x[v,i,j]=1 if vehicle v goes from i to j (customers only)
array[V,C] of var 0..1: y;                   % y[v,i]=1 if vehicle v serves customer i

array[V,C] of var int: t;                    % start-of-service time at customer i by vehicle v
array[V] of var 0..CustomerCount: start_cust; % chosen first customer per vehicle (0 => unused)
array[V] of var 0..CustomerCount: end_cust;   % chosen last customer per vehicle (0 => unused)

var int: total_cost;

% Constraints
% Basic data sanity
constraint forall(c in C)(CustomerDemand[c] >= 0);
constraint forall(v in V)(VehicleCapacity[v] >= 0);

% Link y with routing arcs x
constraint forall(v in V, i in C)(
  sum(j in C where j != i)(x[v,i,j]) = y[v,i]
);
constraint forall(v in V, j in C)(
  sum(i in C where i != j)(x[v,i,j]) = y[v,j]
);

% No self-loops
constraint forall(v in V, i in C)(x[v,i,i] = 0);

% Each customer served exactly once (by exactly one vehicle)
constraint forall(i in C)(
  sum(v in V)(y[v,i]) = 1
);

% Capacity constraints
constraint forall(v in V)(
  sum(i in C)(CustomerDemand[i] * y[v,i]) <= VehicleCapacity[v]
);

% Time windows and time propagation on used arcs (customers-only, no explicit depot)
constraint forall(v in V, i in C)(
  CustomerLBTW[i] <= t[v,i] /\ t[v,i] <= CustomerUBTW[i]
);

constraint forall(v in V, i in C, j in C where i != j)(
  t[v,j] >= t[v,i] + CustomerServiceTime[i] + CustomerDistance[i,j] - BigM * (1 - x[v,i,j])
);

% Define start/end customer per vehicle (0 => vehicle unused)
constraint forall(v in V)(
  (start_cust[v] = 0) <-> (sum(i in C)(y[v,i]) = 0)
);
constraint forall(v in V)(
  (end_cust[v] = 0) <-> (sum(i in C)(y[v,i]) = 0)
);

% Start customer has no incoming arc on that vehicle; end customer has no outgoing arc
constraint forall(v in V, i in C)(
  (start_cust[v] = i) ->
    (y[v,i] = 1 /\ sum(j in C where j != i)(x[v,j,i]) = 0)
);
constraint forall(v in V, i in C)(
  (end_cust[v] = i) ->
    (y[v,i] = 1 /\ sum(j in C where j != i)(x[v,i,j]) = 0)
);

% Exactly one start and one end if vehicle is used
constraint forall(v in V)(
  (sum(i in C)(y[v,i]) > 0) ->
    (start_cust[v] >= 1 /\ end_cust[v] >= 1)
);

% Total cost: travel between customers plus depot legs approximated by start/end
% (No depot distances provided; we approximate depot->start and end->depot as 0.)
constraint total_cost =
  sum(v in V, i in C, j in C)(CustomerDistance[i,j] * x[v,i,j]);

% Objective
solve minimize total_cost;