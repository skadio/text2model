% Mrs. Watson real-estate investment (LP formulated as a MiniZinc model)
% Maximize profit from investing in condos and detached houses.

% Data (embedded)
float: BUDGET = 760000.0;
float: PROFIT_CONDO = 0.50;     % $ profit per $ invested
float: PROFIT_HOUSE = 1.0;      % $ profit per $ invested
float: MIN_CONDO_FRAC = 0.20;   % at least 20% of total investment in condos
float: MIN_HOUSE = 20000.0;     % at least $20000 in detached houses

% Decision variables (dollars invested)
var 0.0..BUDGET: condo;
var 0.0..BUDGET: house;

% Total invested and profit
var 0.0..BUDGET: total_invested = condo + house;
var 0.0..(PROFIT_CONDO*BUDGET + PROFIT_HOUSE*BUDGET): profit
  = PROFIT_CONDO * condo + PROFIT_HOUSE * house;

% Constraints
constraint total_invested <= BUDGET;
constraint condo >= MIN_CONDO_FRAC * total_invested;
constraint house >= MIN_HOUSE;

solve maximize profit;

output [
  "Condo investment = $", show(condo), "\n",
  "House investment = $", show(house), "\n",
  "Total invested    = $", show(total_invested), "\n",
  "Total profit      = $", show(profit), "\n"
];