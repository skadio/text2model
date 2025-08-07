```mzn
%
% The investor chooses how many shares to sell from his portfolio,
% so that the net cash received (after transaction costs and capital gains tax)
% is at least K, while the expected portfolio value next year is maximized.
%
% For each stock i, selling s[i] shares produces:
%   sale_net[i] = s[i] * ( CurrentPrice[i]*(1 - TransactionRate/100)
%                           - (TaxRate/100)*max(0.0, CurrentPrice[i] - BuyPrice[i]) )
%
% and the investor retains (Bought[i]- s[i]) shares which are expected to be worth FuturePrice[i] each.
%
% The overall net cash raised is:
%   NetCash = sum(i in 1..N)( s[i] * (CurrentPrice[i]*(1 - TransactionRate/100)
%                                      - (TaxRate/100)*max(0.0, CurrentPrice[i] - BuyPrice[i]) ) )
%
% The portfolio value next year is:
%   PortfolioValue = sum(i in 1..N)( (Bought[i]-s[i])*FuturePrice[i] ) + NetCash.
%
% We require NetCash >= K and we seek to maximize PortfolioValue.
%

% Data parameters (supplied in a .dzn file)
int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate;  % e.g., 1.0 means 1%
float: TaxRate;          % e.g., 15.0 means 15%
float: K;

% Pre-calculate constant factors for each stock:
array[1..N] of float: cashFactor