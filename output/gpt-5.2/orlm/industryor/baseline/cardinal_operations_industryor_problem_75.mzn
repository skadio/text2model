% Timber purchase, storage, and sales planning (quarters) - LP in MiniZinc
% All data embedded.

include "float.mzn";

enum Q = {Winter, Spring, Summer, Autumn};
int: nQ = 4;

% Data (units: 10,000 yuan per 10,000 m^3 == yuan per m^3, numerically same)
array[Q] of float: buyPrice  = [410.0, 430.0, 460.0, 450.0];
array[Q] of float: sellPrice = [425.0, 440.0, 465.0, 455.0];

% Max sales (units: 10,000 m^3)
array[Q] of float: maxSales = [100.0, 140.0, 200.0, 160.0];

% Warehouse capacity (units: m^3) -> convert to 10,000 m^3
float: capacity = 200000.0 / 10000.0; % = 20.0 (10,000 m^3)

% Storage cost per m^3: a + b*u, where u is storage time in quarters
% Convert to per (10,000 m^3): multiply by 10,000
float: a = 70.0;
float: b = 100.0;

% Decision variables (units: 10,000 m^3)
array[Q] of var float: buy;        % amount purchased in each quarter
array[Q] of var float: sell;       % amount sold in each quarter
array[Q] of var float: inv_end;    % inventory at end of each quarter

% Inventory carried from quarter t-1 to t (same as inv_end[t-1])
array[Q] of var float: carry_to_next;
constraint carry_to_next[Winter] = 0.0;
constraint carry_to_next[Spring] = inv_end[Winter];
constraint carry_to_next[Summer] = inv_end[Spring];
constraint carry_to_next[Autumn] = inv_end[Summer];

% Nonnegativity
constraint forall(q in Q) (buy[q] >= 0.0 /\ sell[q] >= 0.0 /\ inv_end[q] >= 0.0);

% Sales limits
constraint forall(q in Q) (sell[q] <= maxSales[q]);

% Flow balance: inventory end = inventory start + purchase - sales
constraint inv_end[Winter] = 0.0 + buy[Winter] - sell[Winter];
constraint inv_end[Spring] = inv_end[Winter] + buy[Spring] - sell[Spring];
constraint inv_end[Summer] = inv_end[Spring] + buy[Summer] - sell[Summer];
constraint inv_end[Autumn] = inv_end[Summer] + buy[Autumn] - sell[Autumn];

% Capacity limit each quarter (end-of-quarter inventory)
constraint forall(q in Q) (inv_end[q] <= capacity);

% All inventory must be sold by end of autumn
constraint inv_end[Autumn] = 0.0;

% Storage cost is incurred on inventory carried to next quarter:
% cost for inventory held for 1 quarter: (a + b*1) yuan/m^3
% Convert to 10,000 m^3 units: multiply by 10,000
float: storageCostPerQuarterPer10k = (a + b * 1.0) * 10000.0;

var float: revenue = sum(q in Q)(sellPrice[q] * sell[q]);
var float: purchase_cost = sum(q in Q)(buyPrice[q] * buy[q]);
var float: storage_cost =
    storageCostPerQuarterPer10k * (inv_end[Winter] + inv_end[Spring] + inv_end[Summer]);

var float: profit = revenue - purchase_cost - storage_cost;

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Buy (10k m^3):  Winter=", show(buy[Winter]), " Spring=", show(buy[Spring]),
  " Summer=", show(buy[Summer]), " Autumn=", show(buy[Autumn]), "\n",
  "Sell (10k m^3): Winter=", show(sell[Winter]), " Spring=", show(sell[Spring]),
  " Summer=", show(sell[Summer]), " Autumn=", show(sell[Autumn]), "\n",
  "Inv_end (10k m^3): Winter=", show(inv_end[Winter]), " Spring=", show(inv_end[Spring]),
  " Summer=", show(inv_end[Summer]), " Autumn=", show(inv_end[Autumn]), "\n"
];