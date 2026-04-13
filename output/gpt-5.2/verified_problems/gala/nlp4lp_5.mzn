include "globals.mzn";

%=====================
% Input data (.dzn)
%=====================
int: NumLinks;                         % L
array[1..NumLinks] of int: StartNode;  % start of link e
array[1..NumLinks] of int: EndNode;    % end of link e
array[1..NumLinks] of int: Capacity;   % capacity of link e
array[1..NumLinks] of int: Cost;       % per-unit cost on link e

int: NumFlowReqs;                              % F
array[1..NumFlowReqs] of int: SourceNode;      % source of flow f
array[1..NumFlowReqs] of int: DestinationNode; % destination of flow f
array[1..NumFlowReqs] of int: DataRate;        % demand of flow f

%=====================
% Derived sets
%=====================
set of int: NODES =
  { StartNode[e] | e in 1..NumLinks } union
  { EndNode[e]   | e in 1..NumLinks } union
  { SourceNode[f] | f in 1..NumFlowReqs } union
  { DestinationNode[f] | f in 1..NumFlowReqs };

%=====================
% Decision variables
%=====================
% x[e,f] = amount of flow f routed on link e (splittable)
array[1..NumLinks, 1..NumFlowReqs] of var 0..max(DataRate): x;

% total flow on each link (for capacity)
array[1..NumLinks] of var 0..sum(DataRate): linkFlow;

%=====================
% Constraints
%=====================

% Link totals and capacities
constraint forall(e in 1..NumLinks) (
  linkFlow[e] = sum(f in 1..NumFlowReqs)(x[e,f]) /\
  linkFlow[e] <= Capacity[e]
);

% Flow conservation for each commodity (flow requirement)
% For each flow f and node n:
% outflow - inflow = demand at source, -demand at sink, 0 otherwise
constraint
  forall(f in 1..NumFlowReqs, n in NODES) (
    sum(e in 1..NumLinks where StartNode[e] == n)(x[e,f])
  - sum(e in 1..NumLinks where EndNode[e]   == n)(x[e,f])
    =
    (if n == SourceNode[f] then DataRate[f]
     elseif n == DestinationNode[f] then -DataRate[f]
     else 0 endif)
  );

%=====================
% Objective
%=====================
var int: totalCost =
  sum(e in 1..NumLinks, f in 1..NumFlowReqs)(Cost[e] * x[e,f]);

solve minimize totalCost;

%=====================
% Output
%=====================
output [
  "totalCost = ", show(totalCost), "\n",
  "linkFlow  = ", show(linkFlow), "\n",
  "x (by link,flow) =\n",
  concat([ "link " ++ show(e) ++ " (" ++ show(StartNode[e]) ++ "->" ++ show(EndNode[e]) ++ "): "
           ++ show([ x[e,f] | f in 1..NumFlowReqs ]) ++ "\n"
         | e in 1..NumLinks ])
];