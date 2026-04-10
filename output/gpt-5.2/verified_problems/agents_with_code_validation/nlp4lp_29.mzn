% Parameters
int: K;  % number of industries

set of int: I = 1..K;

array[I] of float: ManpowerOne;
array[I] of float: ManpowerTwo;

array[I] of float: Stock;
array[I] of float: Capacity;
array[I] of float: Demand;

array[I, I] of float: InputOne;
array[I, I] of float: InputTwo;

% Use float variables but with explicit finite bounds to avoid Gecode float linear limits
float: BIG = 1.0e9;

array[I] of var 0.0..BIG: production;
array[I] of var 0.0..BIG: invest;
array[I] of var 0.0..BIG: end_stock;

var 0.0..BIG: total_manpower;

% Capacity bound (year-0 proxy)
constraint forall(i in I) (
  production[i] <= Capacity[i]
);

% Stock-flow balance (single-period proxy)
constraint
  forall(j in I) (
    Stock[j] + production[j]
    =
    sum(k in I) ((InputOne[k,j] + InputTwo[k,j]) * production[k])
    +
    sum(k in I) ((InputOne[k,j] + InputTwo[k,j]) * invest[k])
    +
    Demand[j]
    +
    end_stock[j]
  );

% Manpower accounting
constraint
  total_manpower
  =
  sum(i in I) (ManpowerOne[i] * production[i] + ManpowerTwo[i] * invest[i]);

solve maximize total_manpower;