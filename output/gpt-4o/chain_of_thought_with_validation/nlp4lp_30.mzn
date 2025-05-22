array[int, int] of float: Communication;
array[int, int] of float: Cost;
array[int, int] of float: Benefit;

set of int: Departments      = index_set_1of(Communication);
set of int: Cities           = index_set_1of(Cost);
set of int: Benefit_Cities   = index_set_2of(Benefit);

function float: dept_benefit(int: d, int: c) =
    if c in Benefit_Cities then Benefit[d, c] else 0.0 endif;

array[Departments] of var Cities: loc;

constraint
  forall(c in Cities)(
    sum(d in Departments)(bool2int(loc[d] == c)) <= 3
  );

var float: total_communication_cost =
  sum(d1 in Departments, d2 in Departments where d1 < d2)(
    Communication[d1, d2] * Cost[loc[d1], loc[d2]]
  );

var float: total_benefit =
  sum(d in Departments)(dept_benefit(d, loc[d]));

var float: total_yearly_cost = total_communication_cost - total_benefit;

solve minimize total_yearly_cost;