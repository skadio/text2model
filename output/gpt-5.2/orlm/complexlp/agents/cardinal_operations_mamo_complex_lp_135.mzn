% Parameters
int: nCities = 8;                           % number of cities (0..7)
set of int: CITIES = 0..nCities-1;          % city indices
int: source = 0;                            % source city
int: sink = 7;                              % destination city

array[CITIES, CITIES] of int: cap =         % capacity (in thousands of vehicles/hour)
[
  % to:  0   1   2   3   4   5   6   7
        0, 18,  5,  6,  8, 10, 16,  0,   % from 0
       18,  0,  1, 15, 20, 13,  1,  2,   % from 1
       18, 16,  0, 19, 15,  4,  9, 10,   % from 2
       20,  2, 18,  0, 19, 17, 15, 19,   % from 3
       14, 13, 14,  1,  0,  8, 16, 20,   % from 4
        0, 17, 18, 10, 17,  0, 16,  6,   % from 5
        5, 14, 19,  6,  0, 19,  0, 12,   % from 6
        7, 16, 17, 13,  6,  9,  5,  0    % from 7
];

int: maxCap = 20000;                        % explicit upper bound (>= maximum arc capacity)


% Variables
array[CITIES, CITIES] of var 0..maxCap: flow;   % flow on each directed arc (thousands vehicles/hour)
var 0..(nCities * maxCap): totalFlow;            % net s-t flow (objective value)


% Constraints
% Respect arc capacities (including 0 where no direct connection exists)
constraint
  forall(i in CITIES, j in CITIES) (
    flow[i,j] <= cap[i,j]
  );

% No self-loop flow
constraint
  forall(i in CITIES) (
    flow[i,i] = 0
  );

% Flow conservation at intermediate cities (all except source and sink)
constraint
  forall(v in CITIES where v != source /\ v != sink) (
    sum(i in CITIES)(flow[i,v]) = sum(j in CITIES)(flow[v,j])
  );

% Define totalFlow as net flow leaving the source
constraint
  totalFlow = sum(j in CITIES)(flow[source,j]) - sum(i in CITIES)(flow[i,source]);

% Ensure the same totalFlow is the net flow entering the sink
constraint
  totalFlow = sum(i in CITIES)(flow[i,sink]) - sum(j in CITIES)(flow[sink,j]);


% Objective
solve maximize totalFlow;