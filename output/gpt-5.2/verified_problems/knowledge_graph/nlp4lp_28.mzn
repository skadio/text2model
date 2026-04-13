int: K; % number of industries (also used as planning horizon length in provided data)

set of int: I = 1..K;
set of int: T = 0..K; % years 0..K (year 0 given, decision years 1..K)

array[I,I] of float: InputOne;   % intermediate input coefficients (industry i used per unit output of industry j)
array[I]   of float: ManpowerOne; % manpower per unit output for industry i

array[I,I] of float: InputTwo;   % capital-building input coefficients (industry i used per unit capacity-addition of industry j)
array[I]   of float: ManpowerTwo; % manpower per unit capacity-addition for industry i

array[I] of int: Stock;    % initial stocks at start of year 1 (i.e., end of year 0)
array[I] of int: Capacity; % initial productive capacity available in year 1 (year 0 given)

float: ManpowerLimit;      % yearly manpower limit

% Decision variables
array[I, 1..K] of var 0..intmax: prod;     % production of industry i in year t
array[I, 1..K] of var 0..intmax: invest;   % capacity additions started in year t (become available in t+2)
array[I, 0..K] of var 0..intmax: stock;    % end-of-year stocks (stock[i,0] is initial)

% Capacity available in each year
array[I, 1..K] of var 0..intmax: capAvail;

constraint
  forall(i in I) (
    stock[i,0] = Stock[i]
  );

constraint
  forall(i in I, t in 1..K) (
    capAvail[i,t] =
      Capacity[i] + sum(tt in 1..K where tt <= t-2)(invest[i,tt])
  );

% Production cannot exceed available capacity
constraint
  forall(i in I, t in 1..K) (
    prod[i,t] <= capAvail[i,t]
  );

% Yearly manpower limit (production + investment)
constraint
  forall(t in 1..K) (
    sum(i in I)( ManpowerOne[i] * int2float(prod[i,t]) + ManpowerTwo[i] * int2float(invest[i,t]) )
    <= ManpowerLimit
  );

% Material balance with 1-year lag for production inputs:
% Inputs from year t are required for production in year t+1.
constraint
  forall(i in I, t in 0..K-1) (
    stock[i,t+1] =
      stock[i,t]
      + (if t+1 <= K then prod[i,t+1] else 0 endif)
      - sum(j in I)( InputOne[i,j] * int2float(prod[j,t+1]) ) % usage in year t for next year's production
      - (if t+1 <= K then sum(j in I)( InputTwo[i,j] * int2float(invest[j,t+1]) ) else 0 endif) % goods used for starting investments in year t+1
  );

% Ensure nonnegative stocks already enforced by variable domains; also prevent fractional usage exceeding stock implicitly by balance.
% Objective: maximize total production in the last two years (years K-1 and K)
var float: obj =
  sum(i in I)(
    (if K-1 >= 1 then int2float(prod[i,K-1]) else 0.0 endif) +
    int2float(prod[i,K])
  );

solve maximize obj;

output [
  "Objective (total production last two years) = ", show(obj), "\n",
  "prod = ", show(prod), "\n",
  "invest = ", show(invest), "\n",
  "stock = ", show(stock), "\n",
  "capAvail = ", show(capAvail), "\n"
];