% Parameters
int: K;                                 % Number of industries
set of int: INDUSTRIES = 1..K;

array[INDUSTRIES] of float: ManpowerOne;          % Man-power per unit for operation one
array[INDUSTRIES] of float: ManpowerTwo;          % Man-power per unit for operation two
array[INDUSTRIES] of float: Stock;                % Initial stock levels
array[INDUSTRIES] of float: Capacity;             % Existing productive capacity
array[INDUSTRIES] of float: Demand;               % Exogenous consumption demand

array[INDUSTRIES, INDUSTRIES] of float: InputOne; % Input coefficients for operation one
array[INDUSTRIES, INDUSTRIES] of float: InputTwo; % Input coefficients for operation two

float: BIG = 1.0e9;                               % A sufficiently large upper bound

% Variables
array[INDUSTRIES] of var 0.0..BIG: prod_one;      % Output produced via operation one
array[INDUSTRIES] of var 0.0..BIG: build_two;     % Activity level of operation two

% Constraints
% 1. Production cannot exceed existing capacity.
constraint
  forall(i in INDUSTRIES) (
    prod_one[i] <= Capacity[i]
  );

% 2. Material balance for every industry:
%    Initial stock + own production must cover
%    demand plus all inter-industry input requirements.
constraint
  forall(i in INDUSTRIES) (
    Stock[i] + prod_one[i] >=
      Demand[i] +
      sum(j in INDUSTRIES) (
        InputOne[j,i] * prod_one[j] +   % inputs required for op-1 in industry j
        InputTwo[j,i] * build_two[j]    % inputs required for op-2 in industry j
      )
  );

% Objective
maximize
  sum(i in INDUSTRIES) (
    ManpowerOne[i] * prod_one[i] +
    ManpowerTwo[i] * build_two[i]
  );