% Parameters
int: M;                                 % Number of machine types
int: K;                                 % Number of product types
int: I;                                 % Number of time periods

set of int: MACHINES = 1..M;
set of int: PRODUCTS = 1..K;
set of int: PERIODS  = 1..I;
set of int: PERIODSX = 0..I;            % includes initial period 0 for inventory balance

array[MACHINES]           of int   : NumMachines;    % machines available of each type
array[PRODUCTS]           of float : Profit;         % profit per unit sold
array[PRODUCTS, MACHINES] of float : Time;           % processing time per unit on machines
array[MACHINES, PERIODS]  of int   : Maintain;       % machines down for maintenance
array[PRODUCTS, PERIODS]  of int   : Limit;          % maximum units that can be produced
float: StorePrice;                                    % holding cost per unit per period
array[PRODUCTS]           of int   : KeepQuantity;   % minimum inventory to keep
float: WorkHours;                                     % working hours per day

% Fixed parameters that are part of the problem statement
int:   MaxStore    = 100;             % storage capacity per product
float: DaysPerMonth = 24.0;           % working days per period

% Helper upper-bounds
int: MaxProd = max( [ Limit[k,i] | k in PRODUCTS, i in PERIODS ] );
int: MaxSell = MaxProd + MaxStore;

% Decision variables
array[PRODUCTS, PERIODS] of var 0..MaxProd  : Produce;   % quantity manufactured
array[PRODUCTS, PERIODS] of var 0..MaxSell  : Sell;      % quantity sold
array[PRODUCTS, PERIODSX] of var 0..MaxStore: Stock;     % inventory at end of period

% Constraints
%
% 1. Initial inventory
constraint
  forall( k in PRODUCTS )( Stock[k,0] = 0 );

% 2. Inventory balance
constraint
  forall( k in PRODUCTS, i in PERIODS ) (
    Stock[k,i] = Stock[k,i-1] + Produce[k,i] - Sell[k,i]
  );

% 3. Minimum and maximum inventory levels
constraint
  forall( k in PRODUCTS, i in PERIODS ) (
        Stock[k,i] >= KeepQuantity[k]
    /\  Stock[k,i] <= MaxStore
  );

% 4. Production limits
constraint
  forall( k in PRODUCTS, i in PERIODS )( Produce[k,i] <= Limit[k,i] );

% 5. Machine capacity
constraint
  forall( m in MACHINES, i in PERIODS ) (
    sum( k in PRODUCTS )( Time[k,m] * int2float(Produce[k,i]) )
    <= int2float( NumMachines[m] - Maintain[m,i] ) * DaysPerMonth * WorkHours
  );

% Objective
var float: TotalProfit =
      sum( k in PRODUCTS, i in PERIODS )( Profit[k] * int2float(Sell[k,i]) )
    - StorePrice * sum( k in PRODUCTS, i in PERIODS )( int2float(Stock[k,i]) );

solve maximize TotalProfit;