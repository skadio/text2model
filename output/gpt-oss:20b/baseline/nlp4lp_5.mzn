int: NumLinks;
array[1..NumLinks] of int: StartNode;
array[1..NumLinks] of int: EndNode;
array[1..NumLinks] of int: Capacity;
array[1..NumLinks] of int: Cost;
int: NumFlowReqs;
array[1..NumFlowReqs] of int: SourceNode;
array[1..NumFlowReqs] of int: DestinationNode;
array[1..NumFlowReqs] of int: DataRate;

int: L = NumLinks;
int: F = NumFlowReqs;

int: MaxNode = max([max(StartNode), max(EndNode)]);
set of int: Nodes = 1..MaxNode;

var 0..Capacity[l] : x[l in 1..L, f in 1..F];

% Capacity constraints
constraint
  forall(l in 1..L) (
    sum(f in 1..F) x[l,f] <= Capacity[l]
  );

% Flow conservation for each commodity
constraint
  forall(n in Nodes, f in 1..F) (
    let {
      int: inflow = sum(l in 1..L where EndNode[l] == n) x[l,f];
      int: outflow = sum(l in 1..L where StartNode[l] == n) x[l,f];
      int: demand = (if n == SourceNode[f] then +DataRate[f]
                     elseif n == DestinationNode[f] then -DataRate[f]
                     else 0);
    } in
      inflow - outflow == demand
  );

% Objective: minimize total cost
solve minimize
  sum(l in 1..L, f in 1..F) x[l,f] * Cost[l];

% Output
output [
  "Total cost: ", show(sum(l in 1..L, f in 1..F) x[l,f] * Cost[l]), "\n",
  "Flows:\n",
  concat([ "Link ", show(l), " (", show(StartNode[l]), "->", show(EndNode[l]), "):\n",
          concat([ "  Flow ", show(f), ": ", show(x[l,f]), "\n" | f in 1..F]),
          "\n" | l in 1..L])
];