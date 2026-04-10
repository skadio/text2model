% Semicond December production planning with cash/current ratio constraints

% Decision variables: units produced in December
var 0..100: x_tape;   % tape recorders
var 0..100: x_radio;  % radios

% Parameters (per unit)
int: labor_tape = 50;
int: labor_radio = 35;
int: material_tape = 30;
int: material_radio = 40;

int: price_tape = 100;
int: price_radio = 90;

% Starting balance sheet on Dec 1, 2002
int: cash0 = 10000;
int: ar0   = 3000;
int: inv0  = 7000;
int: loan0 = 10000;

% December cash flows
int: ar_collected_dec = 2000;
int: loan_payment_dec = 1000;
int: rent_dec         = 1000;

% January 1, 2003 additional current asset and liability from raw materials received on account
int: materials_received_jan1_value = 2000; % increases inventory and accounts payable (current liability)

% Requirements for Jan 1, 2003
int: min_cash_jan1 = 4000;
int: min_current_ratio_times_den = 2; % ratio >= 2

% Derived expressions
var int: labor_cost_dec    = labor_tape * x_tape + labor_radio * x_radio;
var int: material_cost_dec = material_tape * x_tape + material_radio * x_radio;

% All December sales are on credit: revenue becomes A/R on Jan 1
var int: credit_sales_dec = price_tape * x_tape + price_radio * x_radio;

% Cash on Jan 1 after December activity
var int: cash1 = cash0 + ar_collected_dec - labor_cost_dec - material_cost_dec - loan_payment_dec - rent_dec;

% Current assets on Jan 1:
% cash1 + ending A/R (ar0 - collected + new credit sales) + inventory (inv0 + materials received)
var int: current_assets1 =
  cash1
  + (ar0 - ar_collected_dec + credit_sales_dec)
  + (inv0 + materials_received_jan1_value);

% Current liabilities on Jan 1:
% remaining loan + accounts payable for materials received on Jan 1
var int: current_liabilities1 =
  (loan0 - loan_payment_dec)
  + materials_received_jan1_value;

% Bank current ratio constraint: current_assets1 / current_liabilities1 >= 2
constraint current_assets1 >= min_current_ratio_times_den * current_liabilities1;

% Minimum cash balance on Jan 1
constraint cash1 >= min_cash_jan1;

% Raw material availability on Dec 1: enough to make at most 100 of each (already in var bounds)

% Objective: maximize contribution to profit from December production
% Contribution per unit = selling price - (labor + material)
var int: contribution =
  (price_tape - labor_tape - material_tape) * x_tape
  + (price_radio - labor_radio - material_radio) * x_radio;

solve maximize contribution;

output [
  "x_tape=", show(x_tape), "\n",
  "x_radio=", show(x_radio), "\n",
  "Contribution($)=", show(contribution), "\n",
  "Cash_Jan1=", show(cash1), "\n",
  "CurrentAssets_Jan1=", show(current_assets1), "\n",
  "CurrentLiabilities_Jan1=", show(current_liabilities1), "\n"
];