include "alldifferent.mzn";

int: num_skis;
int: num_skiers;
array[1..num_skis]   of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

int: max_ski_height   = max(ski_heights);
int: min_ski_height   = min(ski_heights);
int: max_skier_height = max(skier_heights);
int: min_skier_height = min(skier_heights);
int: max_possible_diff = max(
    abs(max_ski_height   - min_skier_height),
    abs(max_skier_height - min_ski_height)
);

array[1..num_skiers] of var 1..num_skis: ski_of_skier;
array[1..num_skiers] of var 0..max_possible_diff: disparity;

constraint num_skis >= num_skiers;
constraint alldifferent(ski_of_skier);
constraint forall(i in 1..num_skiers) (
    disparity[i] = abs(skier_heights[i] - ski_heights[ski_of_skier[i]])
);

solve minimize sum(i in 1..num_skiers)(disparity[i]);