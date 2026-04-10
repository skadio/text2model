% Parameters
int: total_investment = 1000000;              % Total amount to invest ($)
int: min_invest_X = 200000;                   % Minimum investment in fund X ($)
int: min_invest_Y = 150000;                   % Minimum investment in fund Y ($)
int: min_invest_Z = 250000;                   % Minimum investment in fund Z ($)

% Returns per dollar invested (as fractions)
float: return_X = 0.02;                       % 2% return for fund X
float: return_Y = 0.03;                       % 3% return for fund Y
float: return_Z = 0.04;                       % 4% return for fund Z


% Variables
var min_invest_X..total_investment: invest_X; % Investment in fund X ($), whole dollars
var min_invest_Y..total_investment: invest_Y; % Investment in fund Y ($), whole dollars
var min_invest_Z..total_investment: invest_Z; % Investment in fund Z ($), whole dollars

var float: total_return;                      % Total return ($) before rounding
var int: total_return_rounded;                % Total return rounded to nearest dollar


% Constraints

% --- Budget balance: invest exactly the total amount ---
constraint invest_X + invest_Y + invest_Z = total_investment;

% --- Define total return from investments ---
constraint
  total_return =
    return_X * int2float(invest_X) +
    return_Y * int2float(invest_Y) +
    return_Z * int2float(invest_Z);

% --- Rounding total return to nearest dollar (half-up) ---
constraint total_return_rounded = round(total_return);


% Objective
solve minimize total_return_rounded;