% Parameters
int: NumLinks;
set of int: Links = 1..NumLinks;

array[Links] of int: StartNode;
array[Links] of int: EndNode;
array[Links] of int: Capacity;
array[Links] of int: Cost;

int: NumFlowReqs;
set of int: Flows = 1..NumFlowReqs;

array[Flows] of int: SourceNode;
array[Flows] of int: DestinationNode;
array[Flows] of int: DataRate;

/* derive the set of nodes present in the network */
int: NumNodes =
    max([ max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode) ]);
set of int: Nodes = 1..NumNodes;

/* handy upper‐bound for variable domains */
int: MaxCap = max(Capacity);

% Variables
array[Flows, Links] of var 0..MaxCap: Flow;        % flow of commodity f on link l
var int: TotalCost = sum(f in Flows, l in Links)(Flow[f,l] * Cost[l]);

% Constraints
/* link‐capacity constraints (total over all commodities) */
constraint
  forall(l in Links)(
    sum(f in Flows)(Flow[f,l]) <= Capacity[l]
  );

/* individual commodity flow must not exceed link capacity */
constraint
  forall(f in Flows, l in Links)(
    Flow[f,l] <= Capacity[l]
  );

/* flow conservation for every commodity at every node */
constraint
  forall(f in Flows, n in Nodes)(
    sum(l in Links where StartNode[l] == n)(Flow[f,l]) -
    sum(l in Links where EndNode[l] == n)(Flow[f,l])
    =
    ( if n == SourceNode[f] then  DataRate[f]
      elseif n == DestinationNode[f] then -DataRate[f]
      else 0 endif )
  );

% Objective
solve minimize TotalCost;