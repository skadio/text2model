% Parameters
int: M;
int: K;
int: I;

set of int: Machines = 1..M;
set of int: Products = 1..K;
set of int: Periods  = 1..I;

% Input data
array[Machines]               of int  : NumMachines;
array[Products]               of float: Profit;
array[Products, Machines]     of float: Time;

% Downtime supplied as a single-row 2-D array to match example data
set of int: SingleRow = 1..1;
array[SingleRow, Machines]    of int  : Downtime;
array[Machines]               of int  : DowntimePerMachine =
    [ Downtime[1,m] | m in Machines ];

array[Products, Periods]      of int  : Limit;
float: StorePrice;
int:   KeepQuantity;
float: WorkHours;

% Aggregated working hours per machine (two shifts, 24 days per month)
float: HoursPerMachine = 2.0 * 24.0 * WorkHours;

% Decision variables
array[Products, Periods] of var int: Produce;          % units produced
array[Products, Periods] of var int: Sell;             % units sold
array[Products, Periods] of var 0..100: Inventory;     % end-of-period stock (capacity 100)
array[Machines, Periods] of var 0..1: Down;            % 1 if all machines of that type are down

% Inventory balance
constraint
  forall(k in Products)(
      Inventory[k,1] = Produce[k,1] - Sell[k,1]
  ) /\
  forall(k in Products, t in 2..I)(
      Inventory[k,t] = Inventory[k,t-1] + Produce[k,t] - Sell[k,t]
  );

% Non-negativity
constraint
  forall(k in Products, t in Periods)(
      Produce[k,t] >= 0 /\ Sell[k,t] >= 0
  );

% Production limits
constraint
  forall(k in Products, t in Periods)(
      Produce[k,t] <= Limit[k,t]
  );

% Storage capacity
constraint
  forall(k in Products, t in Periods)(
      Inventory[k,t] <= 100
  );

% Minimum stock at the end of the planning horizon
constraint
  forall(k in Products)(
      Inventory[k,I] >= KeepQuantity
  );

% Maintenance scheduling
constraint
  forall(m in Machines)(
      sum(t in Periods)(Down[m,t]) = DowntimePerMachine[m]
  );

% Machine time capacity
constraint
  forall(m in Machines, t in Periods)(
      sum(k in Products)(
          Time[k,m] * int2float(Produce[k,t])
      ) <= int2float(NumMachines[m]) * HoursPerMachine * (1.0 - int2float(Down[m,t]))
  );

% Objective: maximise profit
var float: total_profit =
    sum(k in Products, t in Periods)(
        Profit[k] * int2float(Sell[k,t])
    )
  - StorePrice * sum(k in Products, t in Periods)(
        int2float(Inventory[k,t])
    );

solve maximize total_profit;