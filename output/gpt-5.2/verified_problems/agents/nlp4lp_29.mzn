% Parameters
int: K;  % number of products/industries (index set size)

set of int: PROD = 1..K;  % product/industry index set

array[PROD] of float: ManpowerOne;  % manpower requirement for operation type 1 for product k
array[PROD] of float: ManpowerTwo;  % manpower requirement for operation type 2 for product k

array[PROD] of float: Stock;        % initial stock level of product k at beginning of the year
array[PROD] of float: Capacity;     % production capacity for product k for the year
array[PROD] of float: Demand;       % exogenous demand/consumption requirement for product k for the year

array[PROD, PROD] of float: InputOne;  % input-one coefficient: units of j needed per unit of k (op 1)
array[PROD, PROD] of float: InputTwo;  % input-two coefficient: units of j needed per unit of k (op 2)


% Variables
array[PROD] of var float: produce_one;  % amount of product k produced via operation 1
array[PROD] of var float: produce_two;  % amount of product k produced via operation 2

array[PROD] of var float: invest;       % amount of product k allocated to capacity-building (investment)
array[PROD] of var float: end_stock;    % stock of product k at end of the year

var float: total_manpower;              % total manpower used (objective value)


% Constraints

%--------------------------------------------------------------------
% Production capacity limits (total output of each product cannot exceed its capacity)
%--------------------------------------------------------------------
constraint
  forall(k in PROD) (
    produce_one[k] + produce_two[k] <= Capacity[k]
  );

%--------------------------------------------------------------------
% Non-negativity of main decision variables (flows and stock)
%--------------------------------------------------------------------
constraint
  forall(k in PROD) (
    produce_one[k] >= 0.0 /\
    produce_two[k] >= 0.0 /\
    invest[k]      >= 0.0 /\
    end_stock[k]   >= 0.0
  );

%--------------------------------------------------------------------
% Material balance / stock evolution for each product j:
% Supply = initial stock + production
% Uses   = inputs required by all productions + investment + demand + ending stock
%--------------------------------------------------------------------
constraint
  forall(j in PROD) (
    Stock[j] + produce_one[j] + produce_two[j]
    =
    sum(k in PROD) (
      InputOne[k,j] * produce_one[k] + InputTwo[k,j] * produce_two[k]
    )
    + invest[j]
    + Demand[j]
    + end_stock[j]
  );

%--------------------------------------------------------------------
% Total manpower accounting (links total_manpower to production decisions)
%--------------------------------------------------------------------
constraint
  total_manpower =
    sum(k in PROD) (
      ManpowerOne[k] * produce_one[k] + ManpowerTwo[k] * produce_two[k]
    );


% Objective
solve maximize total_manpower;