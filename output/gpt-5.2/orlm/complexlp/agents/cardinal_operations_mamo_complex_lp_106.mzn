% Parameters
int: nCities = 9;                          % Number of cities (0..8)
set of int: Cities = 0..nCities-1;         % City indices

int: source = 0;                           % Warehouse (City 0)
int: sink   = 8;                           % Marketplace (City 8)

array[Cities, Cities] of int: cap =        % Capacity matrix (tons); 0 means no arc
  array2d(Cities, Cities,
  [
    % From City 0
    0, 15, 12,  9,  7, 12,  5, 20, 10,
    % From City 1
    6,  0,  8,  0, 19, 14, 17,  9, 16,
    % From City 2
   19, 11,  0,  0, 13, 14, 17, 10, 13,
    % From City 3
   15,  4,  5,  0,  2, 18,  6, 17, 19,
    % From City 4
    2,  8,  2,  4,  0,  6, 14, 20, 18,
    % From City 5
   14,  9, 18,  7,  4,  0, 11, 11, 13,
    % From City 6
   12, 14, 12,  4, 18,  6,  0,  5,  4,
    % From City 7
   20,  1,  6, 17,  4,  2, 11,  0,  9,
    % From City 8
   16,  6, 14,  0, 17, 17,  6,  9,  0
  ]);

int: maxCap = max([cap[i,j] | i in Cities, j in Cities]);  % Upper bound helper


% Variables
array[Cities, Cities] of var 0..maxCap: flow;                % Flow on each directed arc (tons)
var 0..sum(j in Cities)(cap[source,j]): totalFlow;           % Total shipped from source to sink (tons)


% Constraints

% --- Capacity feasibility: no flow on non-existent arcs and respect arc capacities ---
constraint
  forall(i in Cities, j in Cities) (
    (cap[i,j] = 0 -> flow[i,j] = 0) /\     % forbid flow where no truck/arc exists
    (flow[i,j] <= cap[i,j])               % capacity upper bound on every directed arc
  );

% --- Flow conservation at intermediate cities (standard max-flow conservation) ---
constraint
  forall(k in Cities where k != source /\ k != sink) (
    sum(i in Cities)(flow[i,k]) = sum(j in Cities)(flow[k,j])
  );

% --- Define totalFlow as net outflow from source (equivalently net inflow to sink) ---
constraint
  totalFlow = sum(j in Cities)(flow[source,j]) - sum(i in Cities)(flow[i,source]);

% --- Enforce that the same amount reaches the sink (consistency / correctness) ---
constraint
  totalFlow = sum(i in Cities)(flow[i,sink]) - sum(j in Cities)(flow[sink,j]);


% Objective
solve maximize totalFlow;