include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: M;                         % number of machine types
int: K;                         % number of product types
int: I;                         % number of months (time periods)

array[1..M] of int: NumMachines;          % machines available per type
array[1..K] of float: Profit;             % profit per unit sold of product k
array[1..K, 1..M] of float: Time;         % hours on machine m per unit of product k

% Downtime months for each machine type.
% Either provide as [1..M] (months down at start), or as [1..I,1..M] schedule.
array[int, int] of int: Downtime;         % allowed shapes: [1..M] or [1..I,1..M]

array[1..K, 1..I] of int: Limit;          % max production per product per month
float: StorePrice;                        % holding cost per unit per month
int: KeepQuantity;                        % minimum end-of-month inventory (applies to months 2..I)
float: WorkHours;                         % hours per shift-day (as given)

% Fixed planning assumptions
int: days_per_month = 24;
int: shifts_per_day = 2;
float: base_hours_per_machine_per_month = WorkHours * float(days_per_month * shifts_per_day);

% Storage capacity per product
int: MaxStore = 100;

%----------------------------
% Helper: hours available per machine type and month after downtime
%----------------------------
% Interpret Downtime in one of two ways:
%  - If Downtime is [1..M]: machine type m is down for Downtime[m] initial months.
%  - If Downtime is [1..I,1..M]: Downtime[t,m] is number of machines of type m down in month t.
function float: avail_hours(int: t, int: m) =
  let {
    int: down_machines =
      if index_set_1of2(Downtime) = 1..M /\ index_set_2of2(Downtime) = 1..1 then
        (if t <= Downtime[m,1] then NumMachines[m] else 0 endif)
      elseif index_set_1of2(Downtime) = 1..I /\ index_set_2of2(Downtime) = 1..M then
        Downtime[t,m]
      else
        0
      endif,
    int: up_machines = max(0, NumMachines[m] - down_machines)
  } in
    float(up_machines) * base_hours_per_machine_per_month;

%----------------------------
% Decision variables
%----------------------------
array[1..K, 1..I] of var 0..ub_int(Limit): make;          % units produced
array[1..K, 1..I] of var 0..ub_int(Limit): sell;          % units sold
array[1..K, 0..I] of var 0..MaxStore: stock;              % end-of-month inventory; stock[k,0]=0

% Upper bound helper
function int: ub_int(array[1..K,1..I] of int: a) = max([a[k,t] | k in 1..K, t in 1..I] ++ [0]);

%----------------------------
% Constraints
%----------------------------

% Initial stock
constraint forall(k in 1..K)( stock[k,0] = 0 );

% Production limits
constraint forall(k in 1..K, t in 1..I)( make[k,t] <= Limit[k,t] );

% Inventory flow: stock[t] = stock[t-1] + make - sell
constraint forall(k in 1..K, t in 1..I)(
  stock[k,t] = stock[k,t-1] + make[k,t] - sell[k,t]
);

% Cannot sell more than available
constraint forall(k in 1..K, t in 1..I)(
  sell[k,t] <= stock[k,t-1] + make[k,t]
);

% Storage capacity
constraint forall(k in 1..K, t in 1..I)( stock[k,t] <= MaxStore );

% Minimum stock at end of subsequent months (months 2..I)
constraint forall(k in 1..K, t in 2..I)( stock[k,t] >= KeepQuantity );

% Machine capacity constraints by month and machine type
constraint forall(t in 1..I, m in 1..M)(
  sum(k in 1..K)( Time[k,m] * float(make[k,t]) ) <= avail_hours(t,m)
);

%----------------------------
% Objective: maximize profit = revenue - holding costs
%----------------------------
var float: total_revenue =
  sum(k in 1..K, t in 1..I)( Profit[k] * float(sell[k,t]) );

var float: total_holding_cost =
  sum(k in 1..K, t in 1..I)( StorePrice * float(stock[k,t]) );

solve maximize total_revenue - total_holding_cost;

%----------------------------
% Output
%----------------------------
output [
  "Objective (profit) = ", show(total_revenue - total_holding_cost), "\n",
  "Revenue = ", show(total_revenue), "\n",
  "Holding cost = ", show(total_holding_cost), "\n\n",
  "Make (K x I) = ", show(make), "\n",
  "Sell (K x I) = ", show(sell), "\n",
  "Stock end (K x I) = ", show([ stock[k,t] | k in 1..K, t in 1..I ]), "\n"
];