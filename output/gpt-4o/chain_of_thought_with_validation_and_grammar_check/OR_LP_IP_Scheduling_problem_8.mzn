int: n;
set of int: DAYS = 0..n-1;

array[DAYS] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;
int: part_time_shift;

int: total_demand = sum(demand);
int: max_workers = total_demand;

array[DAYS,DAYS] of int: ft_cover = array2d(DAYS, DAYS,
    [ if ((t - d + n) mod n) < full_time_shift then 1 else 0 endif
      | d in DAYS, t in DAYS ]);

array[DAYS,DAYS] of int: pt_cover = array2d(DAYS, DAYS,
    [ if ((t - d + n) mod n) < part_time_shift then 1 else 0 endif
      | d in DAYS, t in DAYS ]);

array[DAYS] of var 0..max_workers: x_ft;   % full-time workers starting each day
array[DAYS] of var 0..max_workers: x_pt;   % part-time workers starting each day

constraint
  forall(t in DAYS)(
    sum(d in DAYS)(ft_cover[d,t] * x_ft[d]) +
    sum(d in DAYS)(pt_cover[d,t] * x_pt[d]) >= demand[t]
  );

solve minimize
    full_time_pay * full_time_shift * sum(d in DAYS)(x_ft[d]) +
    part_time_pay * part_time_shift * sum(d in DAYS)(x_pt[d]);