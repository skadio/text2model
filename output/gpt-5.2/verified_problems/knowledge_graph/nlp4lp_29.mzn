int: K; % number of industries (=products) and also used as horizon length in provided data

set of int: I = 1..K;
set of int: T = 0..5; % years 0..5 (5-year planning horizon beyond year 0)
set of int: TY = 1..5; % years with demand requirement

array[I] of float: ManpowerOne;
array[I] of float: ManpowerTwo;

array[I] of int: Stock;     % initial stock at beginning of year 0
array[I] of int: Capacity;  % initial production capacity in year 0

array[I] of float: Demand;  % exogenous consumption requirement each year t=1..5

array[I,I] of float: InputOne; % operating inputs: input from j per unit output of i
array[I,I] of float: InputTwo; % investment inputs: input from j per unit capacity increase in i

% Decision variables
array[T, I] of var int: prod;         % production in year t (value units)
array[T, I] of var int: inv;          % investment goods allocated in year t to increase capacity of i (measured in "units of capacity")
array[T, I] of var int: stock;        % stock at beginning of year t
array[T, I] of var int: cap;          % productive capacity available in year t

% Auxiliary: material usage in year t from product j
array[T, I] of var int: use_op;       % total used as operating inputs from product j in year t
array[T, I] of var int: use_inv;      % total used as investment inputs from product j in year t

% Domains
constraint forall(t in T, i in I) (
  prod[t,i] >= 0 /\ inv[t,i] >= 0 /\ stock[t,i] >= 0 /\ cap[t,i] >= 0
);

% Initial conditions (year 0)
constraint forall(i in I) (
  stock[0,i] = Stock[i] /\
  cap[0,i] = Capacity[i]
);

% Capacity limits
constraint forall(t in T, i in I) (
  prod[t,i] <= cap[t,i]
);

% Input accounting (operating and investment demands for each product j in each year t)
% use_op[t,j] = sum_i InputOne[i,j] * prod[t,i]
% use_inv[t,j] = sum_i InputTwo[i,j] * inv[t,i]
constraint forall(t in T, j in I) (
  use_op[t,j] = sum(i in I) (round(InputOne[i,j] * int2float(prod[t,i]))) /\
  use_inv[t,j] = sum(i in I) (round(InputTwo[i,j] * int2float(inv[t,i])))
);

% Stock balance:
% stock[t+1,j] = stock[t,j] + prod[t,j] - use_op[t,j] - use_inv[t,j] - demand_if_applicable
constraint forall(t in 0..4, j in I) (
  stock[t+1,j] = stock[t,j] + prod[t,j] - use_op[t,j] - use_inv[t,j] - round(Demand[j])
);

% For year 5 end stock (no demand specified beyond year 5, but year 5 demand applies in transition from 4 to 5 already)
% Ensure feasibility of using goods in year 5 without needing stock[6]:
% stock[5,j] + prod[5,j] >= use_op[5,j] + use_inv[5,j]
constraint forall(j in I) (
  stock[5,j] + prod[5,j] >= use_op[5,j] + use_inv[5,j]
);

% Capacity evolution with 2-year lag:
% cap[t+1,i] = cap[t,i] + inv[t-1,i]  for t>=1
% with inv[-1,i]=0 and inv[0,i] affects cap[2,i]
constraint forall(i in I) (
  cap[1,i] = cap[0,i]
);
constraint forall(t in 1..4, i in I) (
  cap[t+1,i] = cap[t,i] + inv[t-1,i]
);
% cap[5,i] already defined by t=4 equation; inv[4,i] would affect cap[6] (outside horizon), ignore.

% Objective: maximize total manpower used over 5 years (years 1..5)
% Manpower in year t: sum_i ManpowerOne[i]*prod[t,i] + ManpowerTwo[i]*inv[t,i]
var int: total_manpower =
  sum(t in TY, i in I) (
    round(ManpowerOne[i] * int2float(prod[t,i]) + ManpowerTwo[i] * int2float(inv[t,i]))
  );

solve maximize total_manpower;

output [
  "total_manpower=", show(total_manpower), "\n",
  "prod=\n", show(prod), "\n",
  "inv=\n", show(inv), "\n",
  "stock=\n", show(stock), "\n",
  "cap=\n", show(cap), "\n"
];