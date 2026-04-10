% Oil refining & blending planning model

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
int: I;
int: M;

array[1..I, 1..M] of int: BuyPrice;     % price to buy oil i in month m
int: SellPrice;                         % selling price per ton of final product

array[1..I] of bool: IsVegetable;
int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;                       % total storage capacity (all oils combined)
int: StorageCost;                       % per ton per month for raw oil

float: MaxHardness;
float: MinHardness;
array[1..I] of float: Hardness;

int: InitialAmount;                     % initial storage amount per oil type
int: MinUsage;                          % if used then at least this much refined

array[1..I, 1..I] of int: Dependencies; % 1 => if i used then j used

%%%%%%%%%%
% Variables
%%%%%%%%%%
array[1..I, 1..M] of var 0..StorageSize: buy;
array[1..I, 1..M] of var 0..StorageSize: refine;
array[1..I, 0..M] of var 0..StorageSize: store;

array[1..I, 1..M] of var bool: used;

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%

% initial and final stock per oil type
constraint forall(i in 1..I) ( store[i,0] = InitialAmount );
constraint forall(i in 1..I) ( store[i,M] = InitialAmount );

% inventory balance
constraint forall(i in 1..I, m in 1..M) (
  store[i,m] = store[i,m-1] + buy[i,m] - refine[i,m]
);

% total storage capacity (raw oils only)
constraint forall(m in 1..M) (
  sum(i in 1..I)(store[i,m]) <= StorageSize
);

% refining capacity by line
constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i]) (refine[i,m]) <= MaxVegRefiningPerMonth
);
constraint forall(m in 1..M) (
  sum(i in 1..I where not IsVegetable[i]) (refine[i,m]) <= MaxNonVegRefiningPerMonth
);

% link usage indicator and minimum usage
constraint forall(i in 1..I, m in 1..M) (
  refine[i,m] <= StorageSize * bool2int(used[i,m])
);
constraint forall(i in 1..I, m in 1..M) (
  refine[i,m] >= MinUsage * bool2int(used[i,m])
);

% at most three oils used per month
constraint forall(m in 1..M) (
  sum(i in 1..I)(bool2int(used[i,m])) <= 3
);

% dependency constraints
constraint forall(i in 1..I, j in 1..I, m in 1..M where Dependencies[i,j] = 1) (
  bool2int(used[i,m]) <= bool2int(used[j,m])
);

% hardness constraints (weighted average within bounds if any production)
constraint forall(m in 1..M) (
  let {
    var int: totalRefined = sum(i in 1..I)(refine[i,m]),
    var float: weightedHardness = sum(i in 1..I)(Hardness[i] * int2float(refine[i,m]))
  } in
    ( totalRefined = 0 \/
      ( weightedHardness <= MaxHardness * int2float(totalRefined)
        /\ weightedHardness >= MinHardness * int2float(totalRefined)
      )
    )
);

%%%%%%%%%%%
% Objective
%%%%%%%%%%%
solve maximize
  sum(m in 1..M)(
      SellPrice * sum(i in 1..I)(refine[i,m])
    - sum(i in 1..I)(BuyPrice[i,m] * buy[i,m])
    - StorageCost * sum(i in 1..I)(store[i,m])
  );