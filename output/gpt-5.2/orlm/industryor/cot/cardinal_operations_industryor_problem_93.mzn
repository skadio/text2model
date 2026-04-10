% Parameters (with values embedded)
int: nGas = 2;
set of int: GAS = 1..nGas;          % 1 = Type I, 2 = Type II
set of int: SEG = 1..3;             % purchase price segments for crude A

array[GAS] of int: sellPrice = [4800, 5600];   % yuan per ton
array[GAS] of int: minPropA_percent = [50, 60]; % minimum % of A in each gasoline

int: invA = 500;     % tons of crude A inventory
int: invB = 1000;    % tons of crude B inventory
int: maxPurchaseA = 1500; % tons

array[SEG] of int: segCap = [500, 500, 500];        % max tons in each segment (0-500, 500-1000, 1000-1500)
array[SEG] of int: segCost = [10000, 8000, 6000];   % yuan per ton for each segment

% Variables
array[GAS] of var 0..(invA + maxPurchaseA): useA;   % tons of A used in each gasoline
array[GAS] of var 0..invB: useB;                    % tons of B used in each gasoline
array[SEG] of var 0..500: buySeg;                   % tons bought in each purchase segment
var 0..maxPurchaseA: buyA;                          % total purchased A

% Constraints
constraint buyA = sum(s in SEG)(buySeg[s]);
constraint sum(g in GAS)(useA[g]) <= invA + buyA;
constraint sum(g in GAS)(useB[g]) <= invB;

% Minimum proportion constraints:
% Type I: A >= 50% => useA >= useB
% Type II: A >= 60% => 100*useA >= 60*(useA+useB) => 40*useA >= 60*useB => 2*useA >= 3*useB
constraint forall(g in GAS)(
  if g == 1 then
    useA[g] >= useB[g]
  else
    2 * useA[g] >= 3 * useB[g]
  endif
);

% Segment capacity constraints (already bounded, but keep explicit per instructions)
constraint forall(s in SEG)(buySeg[s] >= 0 /\ buySeg[s] <= segCap[s]);
constraint buyA <= maxPurchaseA;

% Objective
var int: revenue = sum(g in GAS)(sellPrice[g] * (useA[g] + useB[g]));
var int: purchaseCost = sum(s in SEG)(segCost[s] * buySeg[s]);
var int: profit = revenue - purchaseCost;

solve maximize profit;