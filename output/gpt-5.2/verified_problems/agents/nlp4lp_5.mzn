% Parameters
int: NumLinks;                           % number of directed communication links
set of int: LINKS = 1..NumLinks;         % index set of links

array[LINKS] of int: StartNode;          % start node of link l
array[LINKS] of int: EndNode;            % end node of link l
array[LINKS] of int: Capacity;           % capacity of link l (max data per unit time)
array[LINKS] of int: Cost;               % cost per unit data sent on link l

int: NumFlowReqs;                        % number of flow requirements (commodities)
set of int: FLOWS = 1..NumFlowReqs;      % index set of flows

array[FLOWS] of int: SourceNode;         % source node of flow f
array[FLOWS] of int: DestinationNode;    % destination node of flow f
array[FLOWS] of int: DataRate;           % required total amount of flow f to be delivered

% Helper parameters (derived from input)
int: NumNodes =
  max([max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode)]);
set of int: NODES = 1..NumNodes;         % index set of nodes

int: MaxDataRate = max(DataRate);        % max demand among flows (used for variable bounds)


% Variables
array[FLOWS, LINKS] of var 0..MaxDataRate: FlowOnLink;
% FlowOnLink[f,l] = amount of data of flow f routed on link l (nonnegative, split allowed)

array[LINKS] of var 0..sum(DataRate): TotalFlowOnLink;
% TotalFlowOnLink[l] = total data (sum over flows) sent on link l (for capacity/cost accounting)


% Constraints

% Link aggregation: define total flow on each link as sum of all commodities
constraint
  forall(l in LINKS) (
    TotalFlowOnLink[l] = sum(f in FLOWS)(FlowOnLink[f, l])
  );

% Link capacity constraints: total flow on each link cannot exceed its capacity
constraint
  forall(l in LINKS) (
    TotalFlowOnLink[l] <= Capacity[l]
  );

% Flow conservation constraints (multi-commodity flow):
% For each flow f and node n, net outflow - inflow equals:
%   +DataRate[f] at the source, -DataRate[f] at the destination, 0 otherwise.
constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f, l])
    - sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f, l])
    =
    (if n = SourceNode[f] then DataRate[f]
     elseif n = DestinationNode[f] then -DataRate[f]
     else 0 endif)
  );


% Objective
solve minimize sum(l in LINKS)(Cost[l] * TotalFlowOnLink[l]);