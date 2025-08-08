int: T;
array[1..T] of int: Demand;
array[1..T] of int: OilCap;
int: CoalCost;
int: NukeCost;
int: MaxNuke;
int: CoalLife;
int: NukeLife;

array[1..T] of var int: xCoal;
array[1..T] of var int: xNuke;

array[1..T] of var int: CoalCap;
array[1..T] of var int: NukeCap;

constraint forall(t in 1..T) (
    xCoal[t] >= 0 /\ xNuke[t] >= 0
);

constraint forall(t in 1..T) (
    CoalCap[t] = sum(k in 1..t) (xCoal[k] * (if t <= k + CoalLife - 1 then 1 else 0))
);

constraint forall(t in 1..T) (
    NukeCap[t] = sum(k in 1..t) (xNuke[k] * (if t <= k + NukeLife - 1 then 1 else 0))
);

constraint forall(t in 1..T) (
    OilCap[t] + CoalCap[t] + NukeCap[t] >= Demand[t]
    /\ NukeCap[t] <= MaxNuke
);

var int: totalCost = sum(t in 1..T) (CoalCost * xCoal[t] + NukeCost * xNuke[t]);

solve minimize totalCost;

output [
    "Total Cost: ", show(totalCost), "\n",
    "Year | Oil | Coal | Nuclear | Total Capacity\n",
    concat([ show(t) ++ " | " ++ show(OilCap[t]) ++ " | " ++ show(xCoal[t]) ++ " | " ++ show(xNuke[t]) ++ " | " ++ show(OilCap[t] + CoalCap[t] + NukeCap[t]) ++ "\n" | t in 1..T ])
];