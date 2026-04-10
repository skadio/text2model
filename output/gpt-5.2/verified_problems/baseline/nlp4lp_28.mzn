int: K;

array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;

array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;      % initial stock at start of year 1 (i.e., after year 0)
array[1..K] of float: Capacity;   % initial capacity available in year 1
float: ManpowerLimit;

set of int: I = 1..K;
set of int: T = 1..K;

% Decision variables
array[T, I] of var float: x;              % production of industry i in year t
array[T, I] of var float: inv;            % end-of-year inventory of industry i after year t
array[T, I] of var float: invest_out;     % amount of industry i output in year t used as investment goods
array[T, I] of var float: cap;            % productive capacity of industry i available in year t

% Nonnegativity
constraint forall(t in T, i in I) (
  x[t,i] >= 0.0 /\
  inv[t,i] >= 0.0 /\
  invest_out[t,i] >= 0.0 /\
  cap[t,i] >= 0.0
);

% Capacity evolution with 2-year lag:
% Investment made in year (t-2) increases capacity in year t permanently.
constraint forall(i in I) (
  cap[1,i] = Capacity[i] /\
  cap[2,i] = Capacity[i]
);

constraint forall(t in 3..K, i in I) (
  cap[t,i] = cap[t-1,i]
            + sum(j in I)( InputOne[j,i] * invest_out[t-2,j] )
);

% Production limited by available capacity
constraint forall(t in T, i in I) (
  x[t,i] <= cap[t,i]
);

% Inventory balance:
% Each year, output + previous stock covers intermediate inputs for next year's production,
% plus investment goods used in the same year, plus ending inventory.
% Intermediate inputs in year t are those required for production in year t+1.
constraint forall(i in I) (
  inv[1,i] = Stock[i] + x[1,i]
             - invest_out[1,i]
             - (if K >= 2 then sum(j in I)( InputTwo[i,j] * x[2,j] ) else 0.0 endif)
);

constraint forall(t in 2..K, i in I) (
  inv[t,i] = inv[t-1,i] + x[t,i]
             - invest_out[t,i]
             - (if t < K then sum(j in I)( InputTwo[i,j] * x[t+1,j] ) else 0.0 endif)
);

% Investment goods cannot exceed what is available in the year (enforced implicitly by inventory nonnegativity),
% but also must not exceed current production + beginning inventory.
constraint forall(t in T, i in I) (
  invest_out[t,i] <= (if t = 1 then Stock[i] else inv[t-1,i] endif) + x[t,i]
);

% Manpower limit each year:
% Manpower for production uses ManpowerTwo; manpower for investment uses ManpowerOne.
constraint forall(t in T) (
  sum(i in I)( ManpowerTwo[i] * x[t,i] + ManpowerOne[i] * invest_out[t,i] ) <= ManpowerLimit
);

% Objective: maximize total production in the last two years (or only last year if K=1)
var float: obj =
  (if K = 1 then sum(i in I)(x[1,i])
   else sum(i in I)(x[K,i] + x[K-1,i])
   endif);

solve maximize obj;

output [
  "Objective=", show(obj), "\n",
  "Production x(t,i):\n"
] ++
[
  "t=" ++ show(t) ++ ": " ++ show([x[t,i] | i in I]) ++ "\n"
  | t in T
] ++
[
  "Inventory inv(t,i):\n"
] ++
[
  "t=" ++ show(t) ++ ": " ++ show([inv[t,i] | i in I]) ++ "\n"
  | t in T
] ++
[
  "Investment invest_out(t,i):\n"
] ++
[
  "t=" ++ show(t) ++ ": " ++ show([invest_out[t,i] | i in I]) ++ "\n"
  | t in T
] ++
[
  "Capacity cap(t,i):\n"
] ++
[
  "t=" ++ show(t) ++ ": " ++ show([cap[t,i] | i in I]) ++ "\n"
  | t in T
];