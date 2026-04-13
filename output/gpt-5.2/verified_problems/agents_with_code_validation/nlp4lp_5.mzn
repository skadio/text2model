% Parameters

int: NumLinks;                              % number of directed communication links
set of int: LINKS = 1..NumLinks;            % link index set

array[LINKS] of int: StartNode;             % start node of link l
array[LINKS] of int: EndNode;               % end node of link l
array[LINKS] of int: Capacity;              % capacity of link l (max total data on link)
array[LINKS] of int: Cost;                  % cost per unit data on link l

int: NumFlowReqs;                           % number of flow requirements (commodities)
set of int: FLOWS = 1..NumFlowReqs;         % flow requirement index set

array[FLOWS] of int: SourceNode;            % source node of flow f
array[FLOWS] of int: DestinationNode;       % destination node of flow f
array[FLOWS] of int: DataRate;              % required rate (demand) for flow f

% Derive node set from provided link/flow endpoints
int: NumNodes = max([ max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode) ]);
set of int: NODES = 1..NumNodes;            % node index set


% Variables

array[FLOWS, LINKS] of var 0..max(DataRate): FlowOnLink;
% FlowOnLink[f,l] = amount of data of flow f sent on directed link l (nonnegative)

array[LINKS] of var 0..sum(f in FLOWS)(DataRate[f]): TotalFlowOnLink;
% TotalFlowOnLink[l] = total data (all flows combined) sent on link l (nonnegative)

var 0..(max(Cost) * NumLinks * sum(f in FLOWS)(DataRate[f])): TotalCost;
% TotalCost = sum over links and flows of (cost per unit on link * flow on link)


% Constraints

%------------------------------------------------------------
% Link aggregation: total flow on each link equals sum over flows
%------------------------------------------------------------
constraint
  forall(l in LINKS) (
    TotalFlowOnLink[l] = sum(f in FLOWS)(FlowOnLink[f, l])
  );

%------------------------------------------------------------
% Link capacity constraints: combined flow on each link within capacity
%------------------------------------------------------------
constraint
  forall(l in LINKS) (
    TotalFlowOnLink[l] <= Capacity[l]
  );

%------------------------------------------------------------
% Flow conservation for each commodity at every node:
%   outflow - inflow = +DataRate at source,
%                   = -DataRate at destination,
%                   = 0 otherwise
%------------------------------------------------------------
constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f, l])
    - sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f, l])
    =
    (if n = SourceNode[f] then DataRate[f]
     elseif n = DestinationNode[f] then -DataRate[f]
     else 0 endif)
  );

%------------------------------------------------------------
% Total cost definition: sum over all (flow, link) of cost * flow
%------------------------------------------------------------
constraint
  TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * FlowOnLink[f, l]);


% Objective
solve minimize TotalCost;