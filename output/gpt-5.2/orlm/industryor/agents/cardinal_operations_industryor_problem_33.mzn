% Parameters
% Number of product types
int: nTypes = 5;

% Index set for product types
set of int: TYPES = 1..nTypes;

% Type mapping (for readability): 1=A, 2=B, 3=C, 4=D, 5=E

% Available quantities (units) of each type: [A,B,C,D,E]
array[TYPES] of int: qty = [120, 90, 300, 90, 120];

% Weight per unit (tons) of each type: [A,B,C,D,E]
array[TYPES] of float: w = [0.5, 1.0, 0.4, 0.6, 0.65];

% Container capacity bounds (tons)
float: capMax = 60.0;
float: capMin = 18.0;

% Special indices
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;

% Minimum D units per used container
int: minDPerUsed = 12;

% An upper bound on the number of containers (safe bound: one unit per container)
int: maxContainers = sum(t in TYPES)(qty[t]);

% Index set for containers
set of int: CONTAINERS = 1..maxContainers;


% Variables
% x[k,t] = number of units of type t loaded into container k
array[CONTAINERS, TYPES] of var 0..max(qty): x;

% used[k] = 1 if container k is used (loads anything), 0 otherwise
array[CONTAINERS] of var bool: used;

% loadTons[k] = total tons loaded in container k
array[CONTAINERS] of var 0.0..capMax: loadTons;

% total number of containers used (objective helper)
var 0..maxContainers: numUsed;


% Constraints

% --- Demand / inventory satisfaction: ship exactly the available quantity of each type ---
constraint
  forall(t in TYPES)(
    sum(k in CONTAINERS)(x[k,t]) = qty[t]
  );

% --- Define container total load in tons from item counts and per-unit weights ---
constraint
  forall(k in CONTAINERS)(
    loadTons[k] = sum(t in TYPES)(w[t] * int2float(x[k,t]))
  );

% --- Link used[k] with whether any items are placed in container k ---
% If not used => no items; if used => at least one item.
constraint
  forall(k in CONTAINERS)(
    sum(t in TYPES)(x[k,t]) <= sum(t in TYPES)(qty[t]) * bool2int(used[k])
  );
constraint
  forall(k in CONTAINERS)(
    sum(t in TYPES)(x[k,t]) >= bool2int(used[k])
  );

% --- Container capacity constraints (apply only when used) ---
constraint
  forall(k in CONTAINERS)(
    loadTons[k] <= capMax * bool2int(used[k])
  );
constraint
  forall(k in CONTAINERS)(
    loadTons[k] >= capMin * bool2int(used[k])
  );

% --- Packaging requirement: if A is loaded then at least 1 unit of C must also be loaded ---
constraint
  forall(k in CONTAINERS)(
    x[k,C] >= bool2int(x[k,A] > 0)
  );

% --- Minimum D units per used container ---
constraint
  forall(k in CONTAINERS)(
    x[k,D] >= minDPerUsed * bool2int(used[k])
  );

% --- Count containers used (objective helper variable) ---
constraint
  numUsed = sum(k in CONTAINERS)(bool2int(used[k]));


% Objective
solve minimize numUsed;