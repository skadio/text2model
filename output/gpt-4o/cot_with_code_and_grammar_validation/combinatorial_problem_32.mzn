int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of 0..1: participation;

set of int: People = 1..num_people;
set of int: Days   = 1..num_days;

array[Days] of int: participants_count =
  [ sum(p in People)( participation[p,d] ) | d in Days ];

array[People] of float: obligation =
  [ sum(d in Days)(
      if participants_count[d] > 0 then
        int2float(participation[p,d]) / int2float(participants_count[d])
      else
        0.0
      endif
    ) | p in People ];

array[People, Days] of var 0..1: drives;
array[People] of var 0..num_days: actual_drives;

float: max_bound = num_days;
array[People] of var 0.0..max_bound: abs_diff;
var 0.0..max_bound: max_diff;

constraint
  forall(d in Days)(
    if participants_count[d] > 0 then
      sum(p in People)( drives[p,d] ) = 1
    else
      sum(p in People)( drives[p,d] ) = 0
    endif
  );

constraint
  forall(p in People, d in Days)(
    drives[p,d] <= participation[p,d]
  );

constraint
  forall(p in People)(
    actual_drives[p] = sum(d in Days)( drives[p,d] )
  );

constraint
  forall(p in People)(
    abs_diff[p] >= int2float(actual_drives[p]) - obligation[p]
  );

constraint
  forall(p in People)(
    abs_diff[p] >= obligation[p] - int2float(actual_drives[p])
  );

constraint
  forall(p in People)(
    max_diff >= abs_diff[p]
  );

solve minimize max_diff;