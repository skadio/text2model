model

  % Parameters
  int: N;                                 % Number of periods
  float: MaxRegularAmount;                % Max regular production per period
  float: CostRegular;                     % Cost per unit of regular production
  float: CostOvertime;                    % Cost per unit of overtime production
  float: StoreCost;                       % Cost per unit of inventory per period
  array[1..N] of float: Demand;           % Demand in each period

  % Decision variables
  array[1..N] of var float: Regular;      % Regular production in each period
  array[1..N] of var float: Overtime;     % Overtime production in each period
  array[0..N] of var float: Inventory;    % Inventory at the end of each period

  % Constraints
  constraint
    % Inventory balance
    forall(i in 1..N) (
      Inventory[i] = Inventory[i-1] + Regular[i] + Overtime[i] - Demand[i]
    );

    % Production limits
    forall(i in 1..N) (
      Regular[i] >= 0 /\ Regular[i] <= MaxRegularAmount
    );

    % Overtime production must be non‑negative
    forall(i in 1..N) (
      Overtime[i] >= 0
    );

    % Inventory must be non‑negative
    forall(i in 0..N) (
      Inventory[i] >= 0
    );

  % Objective: minimize total cost
  var float: TotalCost = sum(i in 1..N) (
    CostRegular * Regular[i] + CostOvertime * Overtime[i] + StoreCost * Inventory[i]
  );

  solve minimize TotalCost;

  % Output
  output [
    "Regular production: ", show(Regular), "\n",
    "Overtime production: ", show(Overtime), "\n",
    "Ending inventory: ", show(Inventory[1..N]), "\n",
    "Total cost: ", show(TotalCost), "\n"
  ];

end model.