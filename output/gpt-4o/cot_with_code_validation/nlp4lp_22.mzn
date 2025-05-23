int: M;                       % number of machine types
int: K;                       % number of product types
int: I;                       % number of planning periods (months)

set of int: MACHINES  = 1..M;
set of int: PRODUCTS  = 1..K;
set of int: PERIODS   = 1..I;

/* ------------------------------------------------------------------ */
/* input data                                                         */
/* ------------------------------------------------------------------ */
array[MACHINES]              of int   : NumMachines;   % available machines
array[PRODUCTS]              of float : Profit;        % profit per unit sold
array[PRODUCTS, MACHINES]    of float : Time;          % processing time (h) of a product on a machine
array[MACHINES]              of int   : Downtime;      % months each machine type must be down
array[PRODUCTS, PERIODS]     of int   : Limit;         % maximum sales per period
float: StorePrice;                                       % inventory cost per unit per month
int:   KeepQuantity;                                     % storage capacity and required ending stock
float: WorkHours;                                        % hours in one shift
/* ------------------------------------------------------------------ */
/* derived constants                                                  */
/* ------------------------------------------------------------------ */
float: HoursPerMonth = 2.0 * 24.0 * WorkHours;           % 2 shifts/day, 24 days/month

int: LimitMax = max(k in PRODUCTS, t in PERIODS)(Limit[k,t]);
int: XMax     = LimitMax + KeepQuantity;                 % upper bound for production
/* ------------------------------------------------------------------ */
/* decision variables                                                 */
/* ------------------------------------------------------------------ */
array[PRODUCTS, PERIODS] of var 0..XMax        : x;      % produced units
array[PRODUCTS, PERIODS] of var 0..LimitMax    : y;      % sold units
array[PRODUCTS, PERIODS] of var 0..KeepQuantity: s;      % inventory at end of period
array[MACHINES, PERIODS]  of var 0..1          : down;   % 1 if machine type m is down in period i
/* ------------------------------------------------------------------ */
/* constraints                                                        */
/* ------------------------------------------------------------------ */
% 1. maintenance requirements
constraint
  forall(m in MACHINES)(
    sum(i in PERIODS)(down[m,i]) = Downtime[m]
  );

% 2. capacity per machine and period
constraint
  forall(m in MACHINES, i in PERIODS)(
    sum(k in PRODUCTS)(Time[k,m] * x[k,i])
      <= HoursPerMonth * NumMachines[m] * (1 - down[m,i])
  );

% 3. inventory balance
constraint
  forall(k in PRODUCTS)(
    x[k,1] - y[k,1] = s[k,1]
  );

constraint
  forall(k in PRODUCTS, i in 2..I)(
    s[k,i-1] + x[k,i] - y[k,i] = s[k,i]
  );

% 4. sales limited by market
constraint
  forall(k in PRODUCTS, i in PERIODS)(
    y[k,i] <= Limit[k,i]
  );

% 5. storage capacity
constraint
  forall(k in PRODUCTS, i in PERIODS)(
    s[k,i] <= KeepQuantity
  );

% 6. required ending inventory
constraint
  forall(k in PRODUCTS)(
    s[k,I] >= KeepQuantity
  );
/* ------------------------------------------------------------------ */
/* objective                                                          */
/* ------------------------------------------------------------------ */
var float: total_profit =
      sum(k in PRODUCTS, i in PERIODS)(Profit[k] * y[k,i])
    - StorePrice * sum(k in PRODUCTS, i in PERIODS)(s[k,i]);

solve maximize total_profit;