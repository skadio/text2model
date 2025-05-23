int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of float: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

int: MaxPossibleHours = max([Availability[m] + MaxExtra[m] | m in 1..M]);

array[1..P] of int: BatchUpper = [
    min([ (Availability[m] + MaxExtra[m]) div TimeRequired[m,p] 
          | m in 1..M where TimeRequired[m,p] > 0 ])
    | p in 1..P
];

array[1..P] of var 0..max(BatchUpper): Batches;
array[1..M] of var 0..MaxPossibleHours: HoursUsed;
array[1..M] of var 0..MaxPossibleHours: ExtraHours;
var float: Profit;

constraint
    forall(p in 1..P)(
        Batches[p] >= MinBatches[p] /\
        Batches[p] <= BatchUpper[p]
    );

constraint
    forall(m in 1..M)(
        HoursUsed[m] = sum(p in 1..P)(
            TimeRequired[m,p] * Batches[p]
        )
    );

constraint
    forall(m in 1..M)(
        HoursUsed[m] <= Availability[m] + ExtraHours[m]
    );

constraint
    forall(m in 1..M)(
        ExtraHours[m] <= MaxExtra[m]
    );

constraint
    Profit = 
        sum(p in 1..P)( int2float(Prices[p]) * int2float(Batches[p]) ) -
        sum(m in 1..M)(
            MachineCosts[m] * int2float(HoursUsed[m]) + ExtraCosts[m] * int2float(ExtraHours[m])
        );

solve maximize Profit;