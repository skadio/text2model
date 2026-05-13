%--------------------------------------------------------------------
% Parameters (to be supplied by a .dzn file)
%--------------------------------------------------------------------
int: K;
array[1..K,1..K] of float: InputOne;
array[1..K,1..K] of float: InputTwo;
array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;
array[1..K] of float: Stock;
array[1..K] of float: Capacity;
float: ManpowerLimit;

%--------------------------------------------------------------------
% Decision variables
%--------------------------------------------------------------------
% Production of industry k in year t
array[1..K,1..K] of var 0..1000000: prod;

% Capacity of industry k in year t
array[1..K,1..K] of var 0..1000000: cap;

% Stock of product k at the start of year t
array[1..K,1..K] of var 0..1000000: stock;

%--------------------------------------------------------------------
% Constraints
%--------------------------------------------------------------------
% Initial stock and capacity
constraint
  forall(k in 1..K) (
    stock[k,1] = Stock[k]
  ) /\ 
  forall(k in 1..K) (
    cap[k,1] = Capacity[k]
  );

% Capacity growth (two‑year lag)
constraint
  forall(k in 1..K, t in 2..K) (
    if t == 2 then
      cap[k,2] = cap[k,1]
    else
      cap[k,t] = cap[k,t-1] + sum(j in 1..K) prod[j,t-2] * (InputOne[j,k] + InputTwo[j,k])
    endif
  );

% Production cannot exceed capacity
constraint
  forall(k in 1..K, t in 1..K) (
    prod[k,t] <= cap[k,t]
  );

% Stock dynamics (simplified – no consumption)
constraint
  forall(k in 1..K, t in 1..K-1) (
    stock[k,t+1] = stock[k,t] + prod[k,t]
  );

% Annual manpower constraint
constraint
  forall(t in 1..K) (
    sum(k in 1..K) prod[k,t] * (ManpowerOne[k] + ManpowerTwo[k]) <= ManpowerLimit
  );

%--------------------------------------------------------------------
% Objective
%--------------------------------------------------------------------
solve maximize
  sum(k in 1..K) (prod[k,K-1] + prod[k,K]);

%--------------------------------------------------------------------
% Output
%--------------------------------------------------------------------
output [
  "Production:\n",
  show(prod), "\n",
  "Capacity:\n",
  show(cap), "\n",
  "Stock:\n",
  show(stock), "\n"
];