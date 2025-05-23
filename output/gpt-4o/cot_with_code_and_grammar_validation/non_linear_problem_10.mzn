int: ndepts;
int: ncities;
int: ncitiesm1;

array[1..ndepts, 1..ncities] of float: benefit;
array[1..ncities, 1..ncities] of float: dist;
array[1..ndepts, 1..ndepts] of float: comm;

array[1..ndepts] of var 1..ncities: loc;

constraint
    forall(c in 1..ncities)(
        sum(d in 1..ndepts)( bool2int(loc[d] == c) ) <= 3
    );

var float: totalBenefit =
    sum(d in 1..ndepts)( benefit[d, loc[d]] );

var float: totalCommCost =
    sum(d1 in 1..ndepts, d2 in d1+1..ndepts)(
        comm[d1, d2] * dist[loc[d1], loc[d2]]
    );

solve maximize totalBenefit - totalCommCost;