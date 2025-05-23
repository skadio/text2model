int: num_skis;
int: num_skiers;

array[1..num_skis]   of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

int: max_ski_height   = max(i in 1..num_skis)(ski_heights[i]);
int: min_ski_height   = min(i in 1..num_skis)(ski_heights[i]);
int: max_skier_height = max(j in 1..num_skiers)(skier_heights[j]);
int: min_skier_height = min(j in 1..num_skiers)(skier_heights[j]);

int: max_possible_height = max(max_ski_height, max_skier_height);
int: min_possible_height = min(min_ski_height, min_skier_height);
int: max_diff            = max_possible_height - min_possible_height;

array[1..num_skiers] of var 1..num_skis: assigned_ski;
array[1..num_skiers] of var 0..max_diff: disparity;

constraint alldifferent(assigned_ski);

constraint
    forall(i in 1..num_skiers)(
        disparity[i] = abs(ski_heights[assigned_ski[i]] - skier_heights[i])
    );

solve minimize sum(i in 1..num_skiers)(disparity[i]);