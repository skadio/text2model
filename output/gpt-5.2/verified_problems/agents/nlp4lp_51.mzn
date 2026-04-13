% Parameters
int: W;                                   % Number of weeks in planning period
set of int: Weeks = 1..W;                 % Week index set

float: RegularCost;                       % Cost per hour of regular labor
float: OvertimeCost;                      % Cost per hour of overtime labor
float: AssemblyTime;                      % Hours required to assemble one basket
float: MaterialCost;                      % Material cost per basket (not used in objective below unless added)
float: SellingPrice;                      % Selling price per basket
float: HoldingCost;                       % Holding cost per basket per week
float: SalvageValue;                      % Salvage value per unsold basket at end of season

array[Weeks] of int: Demand;              % Demand in each week
array[Weeks] of float: RegularLabor;      % Available regular labor hours each week
array[Weeks] of float: OvertimeLabor;     % Available overtime labor hours each week


% Variables
array[Weeks] of var float: reg_hours;     % Regular labor hours used in week w
array[Weeks] of var float: ot_hours;      % Overtime labor hours used in week w

array[Weeks] of var float: produce;       % Baskets assembled/produced in week w
array[Weeks] of var float: sell;          % Baskets sold in week w
array[Weeks] of var float: inventory;     % End-of-week inventory after sales in week w


% Constraints

%--- Labor capacity limits (regular and overtime) ---
constraint
  forall(w in Weeks)(
    0.0 <= reg_hours[w] /\ reg_hours[w] <= RegularLabor[w]
  );

constraint
  forall(w in Weeks)(
    0.0 <= ot_hours[w] /\ ot_hours[w] <= OvertimeLabor[w]
  );

%--- Production definition from labor hours (assembly time per basket) ---
% produce[w] * AssemblyTime = total labor hours used in week w
constraint
  forall(w in Weeks)(
    produce[w] * AssemblyTime = reg_hours[w] + ot_hours[w]
  );

%--- Nonnegativity and demand-limited sales ---
constraint
  forall(w in Weeks)(
    0.0 <= produce[w]
  );

constraint
  forall(w in Weeks)(
    0.0 <= sell[w] /\ sell[w] <= float(Demand[w])
  );

constraint
  forall(w in Weeks)(
    0.0 <= inventory[w]
  );

%--- Inventory flow balance with zero initial inventory ---
% End inventory = previous inventory + production - sales
constraint
  inventory[1] = produce[1] - sell[1];

constraint
  forall(w in 2..W)(
    inventory[w] = inventory[w-1] + produce[w] - sell[w]
  );

%--- Cannot sell more than available (production + starting inventory) ---
constraint
  sell[1] <= produce[1];

constraint
  forall(w in 2..W)(
    sell[w] <= inventory[w-1] + produce[w]
  );

%--- Demand must be met each week (no backlogging) ---
constraint
  forall(w in Weeks)(
    sell[w] = float(Demand[w])
  );


% Objective
solve maximize
  sum(w in Weeks)(SellingPrice * sell[w])
  + SalvageValue * inventory[W]
  - sum(w in Weeks)(RegularCost * reg_hours[w] + OvertimeCost * ot_hours[w])
  - sum(w in 1..W-1)(HoldingCost * inventory[w]);