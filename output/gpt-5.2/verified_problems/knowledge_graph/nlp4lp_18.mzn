int: N;
set of int: STOCKS = 1..N;

array[STOCKS] of float: Bought;
array[STOCKS] of float: BuyPrice;
array[STOCKS] of float: CurrentPrice;
array[STOCKS] of float: FuturePrice;

float: TransactionRate; % percent (e.g., 1.0 means 1%)
float: TaxRate;         % percent (e.g., 15.0 means 15%)
float: K;

array[STOCKS] of var float: SharesToSell;

constraint forall(i in STOCKS) (
  SharesToSell[i] >= 0.0 /\ SharesToSell[i] <= Bought[i]
);

function var float: gross_proceeds(int: i) =
  SharesToSell[i] * CurrentPrice[i];

function var float: transaction_cost(int: i) =
  (TransactionRate / 100.0) * gross_proceeds(i);

function var float: capital_gain(int: i) =
  SharesToSell[i] * (CurrentPrice[i] - BuyPrice[i]);

function var float: tax_on_gain(int: i) =
  (TaxRate / 100.0) * capital_gain(i);

function var float: net_proceeds(int: i) =
  gross_proceeds(i) - transaction_cost(i) - tax_on_gain(i);

constraint sum(i in STOCKS)( net_proceeds(i) ) = K;

var float: PortfolioValueNextYear =
  sum(i in STOCKS)( (Bought[i] - SharesToSell[i]) * FuturePrice[i] );

solve maximize PortfolioValueNextYear;

output [
  "SharesToSell = ", show(SharesToSell), "\n",
  "PortfolioValueNextYear = ", show(PortfolioValueNextYear), "\n",
  "NetRaised = ", show(sum(i in STOCKS)(net_proceeds(i))), "\n"
];