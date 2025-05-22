% Parameters
int: M;
int: I;

set of int: Months = 1..M;
set of int: Oils   = 1..I;

array[Months, Oils] of int: BuyPrice;      % month, oil
int: SellPrice;

array[Oils] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;        % maximum tons that can be stored for any single oil
int: StorageCost;        % cost per stored ton per month

float: MaxHardness;
float: MinHardness;
array[Oils] of float: Hardness;

int: InitialAmount;      % tons in store (per oil) at the beginning and end of horizon

int: MaxRefiningPerOilPerMonth = max(MaxVegetableRefiningPerMonth,
                                     MaxNonVegetableRefiningPerMonth);

% Decision variables
array[Months, Oils] of var 0..StorageSize: Buy;          % tons purchased
array[Months, Oils] of var 0..MaxRefiningPerOilPerMonth: Use;  % tons refined/used
array[0..M, Oils]  of var 0..StorageSize: Store;         % tons in storage

% Initial stock
constraint
  forall(i in Oils)( Store[0,i] = InitialAmount );

% Inventory balance
constraint
  forall(m in Months, i in Oils)(
    Store[m-1,i] + Buy[m,i] - Use[m,i] = Store[m,i]
  );

% Final stock equals initial
constraint
  forall(i in Oils)( Store[M,i] = InitialAmount );

% Storage capacity
constraint
  forall(m in Months, i in Oils)( Store[m,i] <= StorageSize );

% Refining capacities
constraint
  forall(m in Months)(
       sum(i in Oils where IsVegetable[i])(Use[m,i])     <= MaxVegetableRefiningPerMonth /\
       sum(i in Oils where not IsVegetable[i])(Use[m,i]) <= MaxNonVegetableRefiningPerMonth
  );

% Hardness requirements
constraint
  forall(m in Months)(
    let {
          var int  : total_int = sum(i in Oils)(Use[m,i]),
          var float: total_f   = int2float(total_int),
          var float: hard_sum  = sum(i in Oils)(Hardness[i] * int2float(Use[m,i]))
        } in
    ( total_int = 0 ) \/
    ( MinHardness * total_f <= hard_sum /\ hard_sum <= MaxHardness * total_f )
  );

% Objective: maximise profit
var int: Profit =
        % revenue
        sum(m in Months)( SellPrice * sum(i in Oils)(Use[m,i]) )
        % minus purchase costs
      - sum(m in Months, i in Oils)( BuyPrice[m,i] * Buy[m,i] )
        % minus storage costs
      - sum(m in Months, i in Oils)( StorageCost * Store[m,i] );

solve maximize Profit;