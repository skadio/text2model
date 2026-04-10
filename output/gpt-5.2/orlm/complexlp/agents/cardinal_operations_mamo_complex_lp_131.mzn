% Parameters
int: nCities = 7;                       % Number of cities (0..6)
set of int: Cities = 0..nCities-1;      % City indices
int: source = 0;                        % Central hub
int: sink = 6;                          % End destination

% Capacity matrix (cap[i,j] = max passengers/day from i to j; 0 means no arc)
array[Cities, Cities] of int: cap =
array2d(Cities, Cities,
[
  % to:  0      1      2      3      4      5      6
        0, 18000, 11000, 15000,  2000,  4000, 20000,  % from 0
     4000,     0,  6000,  5000, 19000, 15000,     0,  % from 1
    15000, 10000,     0,  7000,     0,  7000,  5000,  % from 2
    14000,  5000,  3000,     0, 10000, 15000, 19000,  % from 3
     2000, 11000,  1000, 10000,     0, 14000,  6000,  % from 4
    10000, 14000,  6000,  5000,  3000,     0, 18000,  % from 5
     8000,  1000, 11000,  8000,  6000, 20000,     0   % from 6
]);

int: maxCap = max([cap[i,j] | i in Cities, j in Cities]); % Upper bound helper


% Variables
array[Cities, Cities] of var 0..maxCap: flow;   % Passenger flow on each directed arc
var 0..(nCities * maxCap): totalFlow;           % Total passengers sent from source to sink


% Constraints
%-------------------------------------------------------------------------------
% Capacity feasibility: respect capacity bounds
%-------------------------------------------------------------------------------
constraint
  forall(i in Cities, j in Cities) (
    flow[i,j] <= cap[i,j]
  );

%-------------------------------------------------------------------------------
% Capacity & arc-existence enforcement
% - If cap[i,j] = 0 then flow[i,j] must be 0 (no direct railway line)
%-------------------------------------------------------------------------------
constraint
  forall(i in Cities, j in Cities where cap[i,j] = 0) (
    flow[i,j] = 0
  );

%-------------------------------------------------------------------------------
% Flow conservation at intermediate cities (all but source and sink)
%-------------------------------------------------------------------------------
constraint
  forall(k in Cities where k != source /\ k != sink) (
    sum(i in Cities)(flow[i,k]) = sum(j in Cities)(flow[k,j])
  );

%-------------------------------------------------------------------------------
% Define objective value as net outflow from source
%-------------------------------------------------------------------------------
constraint
  totalFlow = sum(j in Cities)(flow[source,j]) - sum(i in Cities)(flow[i,source]);

%-------------------------------------------------------------------------------
% Redundant consistency: totalFlow also equals net inflow at sink
%-------------------------------------------------------------------------------
constraint
  totalFlow = sum(i in Cities)(flow[i,sink]) - sum(j in Cities)(flow[sink,j]);

%-------------------------------------------------------------------------------
% No self-loop flow (optional strengthening; diagonal capacities are 0 in data)
%-------------------------------------------------------------------------------
constraint
  forall(i in Cities) (
    flow[i,i] = 0
  );


% Objective
solve maximize totalFlow;