% Parameters
int: N;                                  % Number of different shares
set of int: SHARES = 1..N;               % Index set for shares

array[SHARES] of float: Bought;          % Initial number of shares held (fractional allowed)
array[SHARES] of float: BuyPrice;        % Purchase price per share
array[SHARES] of float: CurrentPrice;    % Current market price per share
array[SHARES] of float: FuturePrice;     % Expected future market price per share

float: TransactionRate;                  % Transaction cost rate (percent, e.g., 1.0 for 1%)
float: TaxRate;                          % Capital gains tax rate (percent, e.g., 15.0 for 15%)

float: K;                                % Required net cash to raise


% Variables
array[SHARES] of var float: Sell;            % Number of shares to sell now, 0..Bought[i]
array[SHARES] of var float: Hold;            % Shares remaining after selling

array[SHARES] of var float: GrossProceeds;   % CurrentPrice[i] * Sell[i]
array[SHARES] of var float: TransCost;       % Transaction costs on the sale
array[SHARES] of var float: Gain;            % Capital gain: (CurrentPrice - BuyPrice) * Sell
array[SHARES] of var float: Tax;             % Tax on positive gains only

var float: NetRaised;                         % Net cash raised after transaction costs and taxes
var float: FuturePortfolioValue;              % Expected portfolio value next year


% Constraints
% --- Holdings balance and bounds (sell cannot exceed what is owned) ---
constraint
  forall(i in SHARES) (
    0.0 <= Sell[i] /\ Sell[i] <= Bought[i]
  );

constraint
  forall(i in SHARES) (
    Hold[i] = Bought[i] - Sell[i]
  );

% --- Sale proceeds and transaction costs (rates given as percent) ---
constraint
  forall(i in SHARES) (
    GrossProceeds[i] = CurrentPrice[i] * Sell[i]
  );

constraint
  forall(i in SHARES) (
    TransCost[i] = GrossProceeds[i] * (TransactionRate / 100.0)
  );

% --- Capital gains and taxes (tax only on positive gains) ---
constraint
  forall(i in SHARES) (
    Gain[i] = (CurrentPrice[i] - BuyPrice[i]) * Sell[i]
  );

constraint
  forall(i in SHARES) (
    Tax[i] = (TaxRate / 100.0) * max(Gain[i], 0.0)
  );

% --- Net cash raised must meet required amount K ---
constraint
  NetRaised = sum(i in SHARES)(GrossProceeds[i] - TransCost[i] - Tax[i]);

constraint
  NetRaised >= K;

% --- Future portfolio value after selling (value of remaining holdings next year) ---
constraint
  FuturePortfolioValue = sum(i in SHARES)(FuturePrice[i] * Hold[i]);


% Objective
solve maximize FuturePortfolioValue;