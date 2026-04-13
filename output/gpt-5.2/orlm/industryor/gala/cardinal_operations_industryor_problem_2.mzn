% Foldable tables production & workforce planning (Jan–Jun)
% Maximize total net profit with inventory, backorders, in-house production, outsourcing,
% workforce size, hiring/firing, and overtime.

include "globals.mzn";

%----------------------------
% Sets / Time horizon
%----------------------------
int: T = 6;
set of int: M = 1..T;

array[M] of string: month = ["Jan","Feb","Mar","Apr","May","Jun"];

%----------------------------
% Data (embedded as required)
%----------------------------
int: initWorkforce = 1000;
int: initInv = 15000;

array[M] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

int: price = 300;

int: rawMatCost = 90;          % per in-house unit
int: outsourceCost = 200;      % per outsourced unit

int: holdCost = 15;            % per unit end-of-month inventory
int: backCost = 35;            % per unit end-of-month backorder

int: laborHoursPerUnit = 5;

int: regHoursPerWorker = 160;
int: regWage = 30;             % paid for all regular hours regardless of utilization

int: otMaxPerWorker = 20;      % cap per worker per month
int: otWage = 40;

int: hireCost = 5000;
int: fireCost = 8000;

int: minEndInv = 10000;

% Big bounds (safe)
int: maxDemand = max(demand);
int: maxTotalDemand = sum(demand);
int: maxW = 3000;                  % generous workforce upper bound
int: maxProd = maxTotalDemand + initInv;  % generous production bound
int: maxInv = maxTotalDemand + initInv;
int: maxBO = maxTotalDemand;

%----------------------------
% Decision variables
%----------------------------
array[M] of var 0..maxW: W;             % workforce in month t
array[M] of var 0..maxW: hire;          % hired in month t
array[M] of var 0..maxW: fire;          % fired in month t

array[M] of var 0..maxProd: prod;       % in-house production units in month t
array[M] of var 0..maxProd: out;        % outsourced units in month t

array[M] of var 0..(maxW * otMaxPerWorker): otHours; % total overtime hours in month t

array[M] of var 0..maxInv: inv;         % end-of-month inventory
array[M] of var 0..maxBO: bo;           % end-of-month backorder

% Optional: sales (units delivered to customers in month t)
array[M] of var 0..maxTotalDemand: ship;

%----------------------------
% Inventory / backorder flow
% We model "net inventory" N_t = inv_t - bo_t
% Balance: N_t = N_{t-1} + prod_t + out_t - demand_t
% and inv_t, bo_t >= 0 with complementarity not required for correctness in cost model,
% but we can enforce: inv_t * bo_t = 0 is non-linear so we do not.
% Instead, we define shipment explicitly and enforce feasibility:
% ship_t = available to ship; and bo_t is leftover unmet.
%----------------------------

% Start-of-horizon net position:
int: initNet = initInv; % no initial backorders

% Availability and shipment constraints (linear)
% Let startInv_t and startBO_t be previous end states (with t=1 uses initial).
% Demand is satisfied by shipments; unmet becomes bo_t; excess becomes inv_t.
% We can enforce:
%   ship_t + inv_t = startInv_t + prod_t + out_t
%   ship_t + bo_t  = demand_t + startBO_t
% This is a standard linear flow with backorders and inventory.
array[M] of var 0..maxInv: startInv;
array[M] of var 0..maxBO: startBO;

constraint startInv[1] = initInv;
constraint startBO[1] = 0;
constraint forall(t in 2..T)(
  startInv[t] = inv[t-1] /\
  startBO[t]  = bo[t-1]
);

constraint forall(t in M)(
  ship[t] + inv[t] = startInv[t] + prod[t] + out[t] /\
  ship[t] + bo[t]  = demand[t] + startBO[t]
);

%----------------------------
% Workforce dynamics
%----------------------------
constraint W[1] = initWorkforce + hire[1] - fire[1];
constraint forall(t in 2..T)(
  W[t] = W[t-1] + hire[t] - fire[t]
);

%----------------------------
% Capacity constraints: regular hours (paid regardless) + overtime hours produce units
% Total available hours = W*160 + otHours
% Production requires 5 hours per unit
% Overtime cap: otHours <= W*20
%----------------------------
constraint forall(t in M)(
  laborHoursPerUnit * prod[t] <= regHoursPerWorker * W[t] + otHours[t] /\
  otHours[t] <= otMaxPerWorker * W[t]
);

%----------------------------
% Terminal conditions
%----------------------------
constraint inv[T] >= minEndInv;
constraint bo[T] = 0;

%----------------------------
% Objective: maximize net profit over 6 months
% Revenue: price * shipments
% Costs:
%  - raw materials for in-house production
%  - outsourcing cost for outsourced units
%  - inventory holding for end-of-month inv
%  - backorder cost for end-of-month bo
%  - regular wages: regWage * 160 * workforce (paid regardless)
%  - overtime wages: otWage * otHours
%  - hiring/firing costs
%----------------------------
var int: revenue = sum(t in M)(price * ship[t]);

var int: cost_raw = sum(t in M)(rawMatCost * prod[t]);
var int: cost_out = sum(t in M)(outsourceCost * out[t]);
var int: cost_hold = sum(t in M)(holdCost * inv[t]);
var int: cost_back = sum(t in M)(backCost * bo[t]);
var int: cost_regwage = sum(t in M)(regWage * regHoursPerWorker * W[t]);
var int: cost_otwage = sum(t in M)(otWage * otHours[t]);
var int: cost_hirefire = sum(t in M)(hireCost * hire[t] + fireCost * fire[t]);

var int: total_cost = cost_raw + cost_out + cost_hold + cost_back
                    + cost_regwage + cost_otwage + cost_hirefire;

var int: profit = revenue - total_cost;

solve maximize profit;

%----------------------------
% Output
%----------------------------
output
[
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "\n",
  "TotalCost = ", show(total_cost), "\n\n",
  "Month  W   Hire Fire  Prod   Out   OT_hours  Ship   Inv   BO\n"
] ++
[
  month[t], "  ",
  show(W[t]), "  ",
  show(hire[t]), "  ",
  show(fire[t]), "  ",
  show(prod[t]), "  ",
  show(out[t]), "  ",
  show(otHours[t]), "  ",
  show(ship[t]), "  ",
  show(inv[t]), "  ",
  show(bo[t]), "\n"
  | t in M
] ++
[
  "\nCost breakdown:\n",
  "  Raw materials: ", show(cost_raw), "\n",
  "  Outsourcing:   ", show(cost_out), "\n",
  "  Holding:       ", show(cost_hold), "\n",
  "  Backorders:    ", show(cost_back), "\n",
  "  Regular wage:  ", show(cost_regwage), "\n",
  "  Overtime wage: ", show(cost_otwage), "\n",
  "  Hire/Fire:     ", show(cost_hirefire), "\n"
];