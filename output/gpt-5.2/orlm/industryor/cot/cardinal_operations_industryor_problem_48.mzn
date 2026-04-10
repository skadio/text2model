% Parameters (with values embedded)
int: M = 4;
set of int: Months = 1..M;

int: K = 4;
set of int: Lens = 1..K;

array[Months] of int: demand = [1500, 1000, 2000, 1200];            % in m^2
array[Lens] of int: feePer100 = [4000, 7500, 10500, 13000];         % yuan per 100 m^2

% Convert demand to units of 100 m^2 to keep integrality exact
% (All demands are multiples of 100 here.)
array[Months] of int: dem100 = [demand[m] div 100 | m in Months];

% A contract of length l starting at month s provides capacity in months s..s+l-1
set of int: Starts = 1..M;
array[Lens] of set of int: feasibleStarts = [
  {s | s in Starts where s + l - 1 <= M} | l in Lens
];

int: bigM = sum(m in Months)(dem100[m]); % upper bound on total 100m^2 contracted

% Variables
% x[l,s] = area (in 100 m^2 units) rented with a length-l contract starting at month s
array[Lens, Starts] of var 0..bigM: x;

% y[l] indicates whether any contract of length l is used (distinct-length counting + logic)
array[Lens] of var bool: y;

var int: totalCost;

% Constraints
% Disallow infeasible starts (would go beyond month 4)
constraint
  forall(l in Lens, s in Starts where not (s in feasibleStarts[l])) (
    x[l,s] = 0
  );

% Monthly demand must be met exactly (no shortage, no excess)
constraint
  forall(m in Months)(
    sum(l in Lens, s in Starts where (s in feasibleStarts[l]) /\ (s <= m) /\ (m <= s + l - 1)) (x[l,s])
    = dem100[m]
  );

% Link y[l] to usage of contracts of length l
constraint
  forall(l in Lens)(
    sum(s in Starts)(x[l,s]) <= bigM * bool2int(y[l])
  );
constraint
  forall(l in Lens)(
    sum(s in Starts)(x[l,s]) >= bool2int(y[l])  % if y[l]=1, enforce some positive use
  );

% Risk management: at least two different contract lengths must be used
constraint
  sum(l in Lens)(bool2int(y[l])) >= 2;

% Mutual exclusion: if 4-month is chosen, then 1-month is not chosen
constraint
  bool2int(y[4]) + bool2int(y[1]) <= 1;

% At most 3 distinct contract lengths can be used
constraint
  sum(l in Lens)(bool2int(y[l])) <= 3;

% Objective
constraint
  totalCost =
    sum(l in Lens, s in Starts where s in feasibleStarts[l]) (
      x[l,s] * feePer100[l]
    );

solve minimize totalCost;

output [
  "Minimum total rental cost (yuan) = ", show(totalCost), "\n",
  "y (used lengths 1..4) = ", show([fix(y[l]) | l in Lens]), "\n",
  "x[l,s] (in 100 m^2 units, l=1..4, s=1..4):\n",
  concat([ "l=" ++ show(l) ++ ": " ++ show([x[l,s] | s in Starts]) ++ "\n" | l in Lens ])
];