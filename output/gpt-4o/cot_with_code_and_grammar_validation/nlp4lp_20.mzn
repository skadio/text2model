% Parameters
int: I;
int: M;

set of int: Oils = 1..I;
set of int: Months = 1..M;
set of int: Months0 = 0..M;            % month 0 represents the initial stock level

array[Months, Oils] of int: BuyPrice;  % first index = month, second index = oil
int: SellPrice;

array[Oils] of bool: IsVegetable;

int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;
int: StorageCost;

float: MaxHardness;
float: MinHardness;
array[Oils] of float: Hardness;

int: InitialAmount;

int: MinUsage;

array[Oils, Oils] of int: Dependencies; % 1 ⇒ dependency, 0 ⇒ none

% Derived helper sets and constants
set of int: VegOils  = { i | i in Oils where IsVegetable[i] };
set of int: NonVegOils = { i | i in Oils where not IsVegetable[i] };

float: BigM = int2float(StorageSize + MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth);

% Variables
array[Oils, Months]  of var 0.0..BigM                        : Buy;        % tons bought
array[Oils, Months]  of var 0.0..BigM                        : Use;        % tons refined/used
array[Oils, Months0] of var 0.0..int2float(StorageSize)      : Stock;      % raw-oil inventory (end of month, stock[*,0] = initial)
array[Oils, Months]  of var bool                             : UseFlag;    % 1 if oil i is used in month m

% Constraints

% Initial stock fixed
constraint
   forall(i in Oils)( Stock[i,0] = int2float(InitialAmount) );

% Material balance for each oil and month
constraint
   forall(i in Oils, m in Months)(
      Stock[i,m-1] + Buy[i,m] = Use[i,m] + Stock[i,m]
   );

% Final stock must return to initial level
constraint
   forall(i in Oils)( Stock[i,M] = int2float(InitialAmount) );

% Storage capacity (aggregate) each month
constraint
   forall(m in Months)(
      sum(i in Oils)( Stock[i,m] ) <= StorageSize
   );

% Refining capacities per month
constraint
   forall(m in Months)(
      sum(i in VegOils)( Use[i,m] ) <= MaxVegRefiningPerMonth
   );
constraint
   forall(m in Months)(
      sum(i in NonVegOils)( Use[i,m] ) <= MaxNonVegRefiningPerMonth
   );

% Hardness bounds for final product each month
constraint
   forall(m in Months)(
      sum(i in Oils)( (Hardness[i] - MinHardness) * Use[i,m] ) >= 0.0 /\
      sum(i in Oils)( (Hardness[i] - MaxHardness) * Use[i,m] ) <= 0.0
   );

% Linking Use and UseFlag, and minimum usage when selected
constraint
   forall(i in Oils, m in Months)(
        Use[i,m] >= int2float(MinUsage) * int2float(bool2int(UseFlag[i,m])) /\
        Use[i,m] <= BigM * int2float(bool2int(UseFlag[i,m]))
   );

% At most three oils may be used in any month
constraint
   forall(m in Months)(
      sum(i in Oils)( bool2int(UseFlag[i,m]) ) <= 3
   );

% Dependency constraints: if oil i is used, all required oils j must also be used
constraint
   forall(i in Oils, j in Oils where Dependencies[i,j] = 1, m in Months)(
      bool2int(UseFlag[i,m]) <= bool2int(UseFlag[j,m])
   );

% Objective
var float: Profit =
   sum(m in Months)(
         int2float(SellPrice) * sum(i in Oils)( Use[i,m] )
       - sum(i in Oils)( int2float(BuyPrice[m,i]) * Buy[i,m] )
       - int2float(StorageCost) * sum(i in Oils)( Stock[i,m] )
   );

solve maximize Profit;