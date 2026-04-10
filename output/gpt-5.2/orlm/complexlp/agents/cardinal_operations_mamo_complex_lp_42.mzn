% Parameters
int: nWarehouses = 7;                       % number of warehouses
set of int: W = 1..nWarehouses;             % warehouse index set

array[W] of int: supply = [57, 180, 288, 255, 477, 222, 314];   % initial supplies
array[W] of int: demand  = [499, 173, 293, 158, 15, 78, 278];   % required supplies

array[W, W] of int: cost =                                  % unit transport costs
[|  0, 36, 36, 48, 10, 20, 48
 | 28,  0, 16, 18, 36, 42, 12
 |  6, 40,  0, 49, 31,  1, 46
 | 14, 22,  4,  0,  9, 12,  1
 | 50, 44,  7, 48,  0,  7, 25
 | 26,  9, 33, 38,  8,  0, 30
 |  8,  9,  2, 13,  8, 49,  0 |];

int: totalSupply = sum(w in W)(supply[w]);   % total available supply
int: totalDemand = sum(w in W)(demand[w]);   % total required demand

% Variables
array[W, W] of var 0..totalSupply: flow;     % units shipped from i to j
var 0..(totalSupply * max(i,j in W)(cost[i,j])): totalCost;  % total transportation cost upper bound

% Constraints

%--- Feasibility: total supply must cover total demand (otherwise no relocation plan can meet all demands)
constraint totalSupply >= totalDemand;

%--- Disallow self-shipments (keep diagonal flows at 0; avoids pointless cycles with cost 0)
constraint forall(w in W) (flow[w, w] = 0);

%--- Flow conservation / inventory balance at each warehouse:
%    supply[w] - shipped_out[w] + shipped_in[w] = demand[w]
constraint
  forall(w in W) (
    supply[w]
    - sum(j in W)(flow[w, j])
    + sum(i in W)(flow[i, w])
    = demand[w]
  );

%--- Define total transportation cost from flows and unit costs
constraint
  totalCost = sum(i in W, j in W)(cost[i, j] * flow[i, j]);

% Objective
solve minimize totalCost;