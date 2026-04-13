% Parameters
int: K; % Number of departments
int: L; % Number of possible locations (including London if modelled as a location)

set of int: DEPTS = 1..K;
set of int: LOCS  = 1..L;

% Use flexible index sets to avoid mismatch with data (e.g., Benefit given as 1..K x 1..(L-1))
array[int, int] of int: Benefit;          % Benefit for dept k at location l (as provided in .dzn)
array[DEPTS, DEPTS] of float: Communication;
array[LOCS, LOCS] of int: Cost;

% Variables
array[DEPTS] of var LOCS: loc_of_dept;
array[DEPTS, LOCS] of var 0..1: assign;

% Constraints
constraint
  forall(k in DEPTS) (
    sum(l in LOCS)(assign[k,l]) = 1 /\
    loc_of_dept[k] = sum(l in LOCS)(l * assign[k,l])
  );

% Capacity: no location hosts more than 3 departments
constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(assign[k,l]) <= 3
  );

% Channeling
constraint
  forall(k in DEPTS, l in LOCS) (
    (assign[k,l] = 1) <-> (loc_of_dept[k] = l)
  );

% Only allow benefits for locations present in Benefit; treat missing locations as 0 benefit
function int: benefit_at(int: k, int: l) =
  if exists(ll in index_set_2of2(Benefit) where ll = l) then Benefit[k,l] else 0 endif;

% Objective: communication cost minus benefits
solve minimize
  sum(k in DEPTS, j in DEPTS)(
    Communication[k,j] * Cost[loc_of_dept[k], loc_of_dept[j]]
  )
  - sum(k in DEPTS, l in LOCS)(
    benefit_at(k,l) * assign[k,l]
  );