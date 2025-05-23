% Parameters
int: N;
array[1..N] of float: AssemblyHour;
array[1..N] of float: TestingHour;
array[1..N] of float: MaterialCost;
float: MaxAssembly;
float: MaxTesting;
array[1..N] of float: Price;
float: MaxOvertimeAssembly;
float: OvertimeAssemblyCost;
float: MaterialDiscount;          % percentage (e.g. 10 means 10 %)
float: DiscountThreshold;         % material–cost threshold to trigger discount

% ------------------------------------------------------------------------
% Derived constants
float: pDiscount               = MaterialDiscount / 100.0;
float: minAssemblyHour         = min(i in 1..N)(AssemblyHour[i]);
float: maxUnitsByAssembly      = (MaxAssembly + MaxOvertimeAssembly) / minAssemblyHour;
float: minTestingHour          = min(i in 1..N)(TestingHour[i]);
float: maxUnitsByTesting       =  MaxTesting / minTestingHour;
float: maxUnitsPossible        = max(maxUnitsByAssembly, maxUnitsByTesting);
float: maxMaterialCostPerUnit  = max(i in 1..N)(MaterialCost[i]);
float: bigM                    = maxUnitsPossible * maxMaterialCostPerUnit;
int:   UBAll                   = ceil(maxUnitsPossible);        % coarse upper bound for each product

% ------------------------------------------------------------------------
% Variables
array[1..N] of var int:          X;                  % quantity produced
var 0.0..MaxOvertimeAssembly:    overtime_used;      % overtime assembly hours
var bool:                        discountApplied;    % 1 ⇔ discount is granted
var 0.0..bigM:                   raw_material_cost;
var 0.0..bigM:                   w;                  % linearisation helper: w = raw_material_cost * discountApplied
var 0.0..bigM:                   discounted_material_cost;
var float:                       revenue;
var float:                       profit;

% ------------------------------------------------------------------------
% Constraints
constraint
    forall(i in 1..N)( X[i] >= 0 /\ X[i] <= UBAll );

constraint
    sum(i in 1..N)(AssemblyHour[i] * X[i]) <= MaxAssembly + overtime_used;

constraint
    sum(i in 1..N)(TestingHour[i] * X[i])  <= MaxTesting;

constraint
    raw_material_cost = sum(i in 1..N)(MaterialCost[i] * X[i]);

constraint
    revenue = sum(i in 1..N)(Price[i] * X[i]);

% Threshold – discount logic
constraint
    discountApplied = (raw_material_cost >= DiscountThreshold);

% Linearisation of  w = raw_material_cost * discountApplied
constraint
        w <= raw_material_cost
    /\  w <= bigM * bool2int(discountApplied)
    /\  w >= raw_material_cost - bigM * (1 - bool2int(discountApplied))
    /\  w >= 0.0;

% Discounted material cost
constraint
    discounted_material_cost = raw_material_cost - pDiscount * w;

% Profit definition
constraint
    profit = revenue
             - discounted_material_cost
             - OvertimeAssemblyCost * overtime_used;

% ------------------------------------------------------------------------
% Objective
solve maximize profit;