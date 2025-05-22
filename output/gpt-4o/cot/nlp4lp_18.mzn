% Parameters
int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate;          % expressed as a percentage, e.g., 1.0 = 1 %
float: TaxRate;                  % expressed as a percentage, e.g., 15.0 = 15 %
float: K;                        % amount of money to raise (net)

% Derived data
array[1..N] of float: PosGain = [ max(0.0, CurrentPrice[i] - BuyPrice[i]) | i in 1..N ];
float: MaxBought = max(i in 1..N)(Bought[i]);

% Variables
array[1..N] of var 0.0..MaxBought: Sell;   % number of shares to sell

% Constraints
constraint
  forall(i in 1..N) (
    Sell[i] <= Bought[i]        % cannot sell more than currently held
  );

constraint
  (
    /* Net cash raised = gross revenue − transaction costs − taxes */
    let {
      float: tc = TransactionRate / 100.0,
      float: tr = TaxRate / 100.0
    } in
      sum(i in 1..N)( Sell[i] * CurrentPrice[i] )                           % gross
    - tc * sum(i in 1..N)( Sell[i] * CurrentPrice[i] )                      % transaction cost
    - tr * sum(i in 1..N)( Sell[i] * PosGain[i] )                           % capital-gains tax
    >= K
  );

% Objective
solve maximize
  sum(i in 1..N)(
      (Bought[i] - Sell[i]) * FuturePrice[i]    % expected value of remaining shares
  );