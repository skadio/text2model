include "globals.mzn";

%% ----------------------------------------------------------------------
%%  Parameters – supplied from the .dzn data file
%% ----------------------------------------------------------------------
int: NumLinks;

array[1..NumLinks] of int: StartNode;      %% starting node of each directed link
array[1..NumLinks] of int: EndNode;        %% ending node of each directed link
array[1..NumLinks] of int: Capacity;       %% capacity of each link
array[1..NumLinks] of int: Cost;           %% cost per unit of data on each link

int: NumFlowReqs;                          %% number of distinct data flows

array[1..NumFlowReqs] of int: SourceNode;   %% source node for each flow
array[1..NumFlowReqs] of int: DestinationNode; %% destination node for each flow
array[1..NumFlowReqs] of int: DataRate;       %% required data rate for each flow


%% ----------------------------------------------------------------------
%%  Derived constants
%% ----------------------------------------------------------------------
int: MaxNode = max([max(StartNode), max(EndNode)]);  %% upper bound on node indices
int: NodeCount = MaxNode;  %% we assume node indices start at 1 and are contiguous


%% ----------------------------------------------------------------------
%%  Decision variables
%% ----------------------------------------------------------------------
array[1..NumLinks, 1..NumFlowReqs] of var 0..max(Capacity): flow;  

%% ----------------------------------------------------------------------
%%  Constraints
%% ----------------------------------------------------------------------
%%  (1) Capacity constraints – total flow on a link cannot exceed its capacity
constraint
  forall(l in 1..NumLinks) (
    sum(f in 1..NumFlowReqs)( flow[l,f] ) <= Capacity[l]
  );

%%  (2) Flow conservation for every node and every commodity
constraint
  forall(n in 1..NodeCount, f in 1..NumFlowReqs) (
    let {
      int: demand = 
        if n == SourceNode[f]      then  DataRate[f]
        elseif n == DestinationNode[f] then -DataRate[f]
        else 0
    } in
    sum(l in 1..NumLinks where StartNode[l] == n)( flow[l,f] )
    -
    sum(l in 1..NumLinks where EndNode[l]   == n)( flow[l,f] )
    ==
    demand
  );


%% ----------------------------------------------------------------------
%%  Objective – minimize total transportation cost
%% ----------------------------------------------------------------------
solve minimize
  sum(l in 1..NumLinks, f in 1..NumFlowReqs)( flow[l,f] * Cost[l] );


%% ----------------------------------------------------------------------
%%  Output
%% ----------------------------------------------------------------------
output [
  "Total cost = ", show(sum(l in 1..NumLinks, f in 1..NumFlowReqs)( flow[l,f] * Cost[l] )), "\n",
  "Link flows (link # : [flow for each commodity]):\n",
  concat([ show(l) ++ " : " ++ show([ flow[l,f] | f in 1..NumFlowReqs ]) ++ "\n" | l in 1..NumLinks ])
];