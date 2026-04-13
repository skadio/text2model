int: M; % number of machine types
int: K; % number of product types
int: I; % number of time periods (months)

array[1..M] of int: NumMachines;          % number of machines of each type
array[1..K] of float: Profit;             % profit per unit sold of each product
array[1..K, 1..M] of float: Time;         % hours required on machine m to make 1 unit of product k
array[1..M, 1..I] of int: Downtime;       % number of machines of type m down in period i
array[1..K, 1..I] of int: Limit;          % max production of product k in period i
float: StorePrice;                        % cost per unit held in inventory per period
int: KeepQuantity;                        % minimum ending inventory requirement (each product, each period)
float: WorkHours;                         % hours per shift per day (given)
% Assumptions from statement:
int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
int: MaxStore = 100;                      % max inventory per product

set of int: MACH = 1..M;
set of int: PROD = 1..K;
set of int: PER  = 1..I;

% Effective available machine-hours per period for each machine type
array[MACH, PER] of float: CapHours =
  array2d(MACH, PER,
    [ max(0.0, float(NumMachines[m] - Downtime[m,i])) * float(DaysPerMonth * ShiftsPerDay) * WorkHours
    | m in MACH, i in PER ]);

% Decision variables
array[PROD, PER] of var 0..max(Limit): Make;     % units manufactured
array[PROD, PER] of var 0..max(Limit): Sell;     % units sold
array[PROD, PER] of var 0..MaxStore: Stock;      % end-of-period inventory

% Inventory flow (start with zero stock)
constraint forall(k in PROD) (
  Stock[k,1] = Make[k,1] - Sell[k,1]
);
constraint forall(k in PROD, i in 2..I) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

% Cannot sell more than available
constraint forall(k in PROD) (
  Sell[k,1] <= Make[k,1]
);
constraint forall(k in PROD, i in 2..I) (
  Sell[k,i] <= Stock[k,i-1] + Make[k,i]
);

% Production limits
constraint forall(k in PROD, i in PER) (
  Make[k,i] <= Limit[k,i]
);

% Storage limits and minimum ending stock requirements (end of subsequent months)
constraint forall(k in PROD, i in PER) (
  Stock[k,i] <= MaxStore
);
constraint forall(k in PROD, i in PER) (
  Stock[k,i] >= KeepQuantity
);

% Machine capacity constraints (hours)
constraint forall(m in MACH, i in PER) (
  sum(k in PROD)( Time[k,m] * Make[k,i] ) <= CapHours[m,i]
);

% Objective: maximize profit from sales minus storage cost for held inventory
var float: TotalProfit =
  sum(i in PER, k in PROD)( Profit[k] * Sell[k,i] )
  - StorePrice * sum(i in PER, k in PROD)( Stock[k,i] );

solve maximize TotalProfit;

output [
  "TotalProfit = ", show(TotalProfit), "\n",
  "Make =\n", show(Make), "\n",
  "Sell =\n", show(Sell), "\n",
  "Stock =\n", show(Stock), "\n"
];