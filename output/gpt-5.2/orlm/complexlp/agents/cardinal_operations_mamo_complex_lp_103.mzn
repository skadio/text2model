% Parameters
int: n = 8;                          % number of cities (nodes)
set of int: CITIES = 0..n-1;         % city indices
int: source = 0;                     % source city
int: sink = 7;                       % destination city

% Capacity matrix: cap[i,j] is max tons/day on directed road i->j (0 means no road)
array[CITIES, CITIES] of int: cap =
  [|  0, 11,  1,  6,  4,  5,  7,  1
   |  3,  0, 15, 15, 16,  9, 14, 12
   | 19,  9,  0,  5,  9, 11, 16,  3
   | 15,  1, 14,  0,  0,  4,  1, 15
   |  8, 16,  7,  3,  0, 16, 10, 11
   |  7,  8,  1, 11, 19,  0,  3,  3
   |  2, 19,  2,  6, 12, 20,  0,  6
   | 15, 17,  4,  7,  8,  2, 16,  0 |];

int: max_cap = max([cap[i,j] | i in CITIES, j in CITIES]); % for variable bounds


% Variables
array[CITIES, CITIES] of var 0..max_cap: flow;  % tons/day sent on road i->j

% Upper bound: total outgoing capacity from source (simple safe bound)
var 0..sum(j in CITIES)(cap[source,j]): max_flow; % total tons/day delivered source->sink


% Constraints

% Capacity compliance: no flow can exceed the given road capacity (and 0-capacity implies 0 flow)
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

% No self-loops: disallow sending flow from a city to itself
constraint
  forall(i in CITIES) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate cities (all except source and sink):
% incoming flow equals outgoing flow
constraint
  forall(k in CITIES where k != source /\ k != sink) (
    sum(i in CITIES)(flow[i,k]) = sum(j in CITIES)(flow[k,j])
  );

% Define max_flow as total net outflow from source (equivalently, inflow to sink in a conserved network)
constraint
  max_flow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Ensure consistency at sink: max_flow equals net inflow to sink
constraint
  max_flow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);


% Objective
solve maximize max_flow;