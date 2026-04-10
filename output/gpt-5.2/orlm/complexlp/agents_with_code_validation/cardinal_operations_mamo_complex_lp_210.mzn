% Parameters
% Product set
int: nProducts = 2;
set of int: PRODUCTS = 1..nProducts;

int: TAPE = 1;
int: RADIO = 2;

% Unit economics ($/unit)
array[PRODUCTS] of int: labor_cost = [50, 35];
array[PRODUCTS] of int: material_cost = [30, 40];
array[PRODUCTS] of int: selling_price = [100, 90];

% Raw material availability expressed as max producible units from current raw material stock (Dec 1)
array[PRODUCTS] of int: max_units_from_material = [100, 100];

% Balance sheet at Dec 1, 2002 ($)
int: cash0 = 10000;
int: accounts_receivable0 = 3000;
int: inventory0 = 7000;              % value of inventory on hand (current asset)
int: loan0 = 10000;                  % current liability

% December cash-flow / obligations ($)
int: ar_collected_in_december = 2000;  % cash collected in December from prior AR
int: loan_principal_payment_dec = 1000;
int: rent_payment_dec = 1000;

% Jan 1, 2003 incoming raw materials (current asset) and matching liability due Feb 1 ($)
int: incoming_material_value_jan1 = 2000;  % increases inventory and accounts payable

% Policy / covenant requirements at Jan 1, 2003
int: min_cash_jan1 = 4000;
int: min_current_ratio_num = 2;  % current ratio >= 2

% Profit contribution per unit ($)
array[PRODUCTS] of int: unit_contribution =
  [selling_price[p] - labor_cost[p] - material_cost[p] | p in PRODUCTS];

% Helper bounds
int: max_total_units = sum(p in PRODUCTS)(max_units_from_material[p]);
int: max_profit = sum(p in PRODUCTS)(max_units_from_material[p] * unit_contribution[p]);

% Variables
% Production quantities in December (units)
array[PRODUCTS] of var 0..max_total_units: produce;

% End-of-period (Jan 1, 2003) balance sheet components ($)
var 0..(cash0 + ar_collected_in_december): cash_jan1;
var 0..(accounts_receivable0 + sum(p in PRODUCTS)(selling_price[p] * max_units_from_material[p])): accounts_receivable_jan1;
var 0..(inventory0 + incoming_material_value_jan1 + sum(p in PRODUCTS)(material_cost[p] * max_units_from_material[p])): inventory_jan1;

var 0..loan0: loan_jan1;
var 0..incoming_material_value_jan1: accounts_payable_jan1;

% Objective: maximal contribution to profit from December production ($)
var 0..max_profit: profit;

% Constraints

%-----------------------------------------------------------------------
% Production feasibility (raw material limits as max producible units)
%-----------------------------------------------------------------------
constraint
  forall(p in PRODUCTS) (
    produce[p] <= max_units_from_material[p]
  );

%-----------------------------------------------------------------------
% End-of-period (Jan 1) balance sheet flow definitions
%   Assumption consistent with given data: inventory is valued at material cost.
%   All December sales are on credit -> increase Accounts Receivable, no cash from sales.
%   December production consumes raw materials -> reduces inventory by material_cost * units.
%   Jan 1 incoming materials add inventory and create accounts payable (liability).
%-----------------------------------------------------------------------
constraint
  accounts_receivable_jan1 =
    accounts_receivable0 + sum(p in PRODUCTS)(selling_price[p] * produce[p]);

constraint
  inventory_jan1 =
    inventory0
    - sum(p in PRODUCTS)(material_cost[p] * produce[p])
    + incoming_material_value_jan1;

constraint
  accounts_payable_jan1 = incoming_material_value_jan1;

constraint
  loan_jan1 = loan0 - loan_principal_payment_dec;

%-----------------------------------------------------------------------
% Cash balance at Jan 1 (cash movements in December)
%   Cash increases by AR collected; decreases by rent and loan principal payment.
%   No cash collected from December sales (credit terms).
%-----------------------------------------------------------------------
constraint
  cash_jan1 =
    cash0
    + ar_collected_in_december
    - loan_principal_payment_dec
    - rent_payment_dec;

%-----------------------------------------------------------------------
% Policy requirement: minimum cash balance at Jan 1
%-----------------------------------------------------------------------
constraint
  cash_jan1 >= min_cash_jan1;

%-----------------------------------------------------------------------
% Bank covenant: current ratio at Jan 1 must be at least 2
%   Current assets: cash + accounts receivable + inventory
%   Current liabilities: loan + accounts payable
%   Enforce ratio without division: assets >= 2 * liabilities
%-----------------------------------------------------------------------
constraint
  cash_jan1 + accounts_receivable_jan1 + inventory_jan1 >=
    min_current_ratio_num * (loan_jan1 + accounts_payable_jan1);

%-----------------------------------------------------------------------
% Profit contribution from December production
%-----------------------------------------------------------------------
constraint
  profit = sum(p in PRODUCTS)(unit_contribution[p] * produce[p]);

% Objective
solve maximize profit;