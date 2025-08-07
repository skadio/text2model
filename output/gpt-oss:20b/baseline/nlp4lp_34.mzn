int: T;
int: K;

array[1..T] of int: Demand;
array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;
array[1..K] of int: RunCost;
array[1..K] of float: ExtraCost;
array[1..K] of int: StartCost;

array[1..K, 1..T] of var int: numOn;
array[1..K, 1..T] of var int: production;
array[1..K, 1..T] of var int: startUp;

var float: totalCost = sum(k in 1..K, t in 1..T) (
    RunCost[k] * numOn[k][t]
    + ExtraCost[k] * (production[k][t] - MinLevel[k] * numOn[k][t])
    + StartCost[k] * startUp[k][t]
);

constraint
    % Production limits
    forall(k in 1..K, t in 1..T) (
        production[k][t] >= MinLevel[k] * numOn[k][t]
        /\ production[k][t] <= MaxLevel[k] * numOn[k][t]
    )
    /\ % Number of units on cannot exceed available units
    forall(k in 1..K, t in 1..T) (
        numOn[k][t] <= NumGenerator[k]
    )
    /\ % Start‑up definition
    forall(k in 1..K, t in 1..T) (
        startUp[k][t] >= numOn[k][t] - (if t == 1 then 0 else numOn[k][t-1] endif)
        /\ startUp[k][t] <= numOn[k][t]
        /\ startUp[k][t] <= NumGenerator[k] - (if t == 1 then 0 else numOn[k][t-1] endif)
        /\ startUp[k][t] >= 0
    )
    /\ % Demand must be met
    forall(t in 1..T) (
        sum(k in 1..K) production[k][t] >= Demand[t]
    );

solve minimize totalCost;

output [
    "Total Cost: ", show(totalCost), "\n",
    "Period ", show(t), ":\n",
    "  NumOn: ", show([numOn[k][t] | k in 1..K]), "\n",
    "  Production: ", show([production[k][t] | k in 1..K]), "\n"
    | t in 1..T
];