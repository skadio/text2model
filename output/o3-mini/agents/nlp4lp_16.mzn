%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data declarations (to be provided via a .dzn file)
int: N;
array[1..N] of float: AssemblyHour;      % hours required to assemble product i
array[1..N] of float: TestingHour;         % hours required to test product i
array[1..N] of float: MaterialCost;        % material cost for product i
float: MaxAssembly;                        % maximum regular assembly hours available
float: MaxTesting;                         % maximum testing hours available
array[1..N] of float: Price;               % selling price for product i
float: MaxOvertimeAssembly;                % maximum overtime assembly hours allowed
float: OvertimeAssemblyCost;               % overtime cost per assembly hour
float: MaterialDiscount;                   % discount percentage on material cost
float: DiscountThreshold;                  % threshold for raw material bill to get discount

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision variables: production quantities for each product (non-negative integers)
array[1..N] of var int: production;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resource constraints

% The total assembly hours (from both regular and overtime) cannot exceed the sum of available hours.
constraint sum(i in 1..N)( production[i] * AssemblyHour[i] ) 
         <= MaxAssembly + MaxOvertimeAssembly;
         
% The total testing hours must not exceed the available testing hours.
constraint sum(i in 1..N)( production[i] * TestingHour[i] ) 
         <= MaxTesting;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective: maximize daily profit
%
% Let:
%   revenue       = sum_i ( production[i] * Price[i] )
%   raw_material  = sum_i ( production[i] * MaterialCost[i] )
%   effective_material_cost = 
%         if raw_material >= DiscountThreshold then 
%              raw_material * (1 - MaterialDiscount/100)
%         else
%              raw_material
%         endif
%   assembly_total = sum_i ( production[i] * AssemblyHour[i] )
%   overtime_used  = if assembly_total > MaxAssembly then assembly_total - MaxAssembly else 0 endif
%   overtime_cost  = overtime_used * OvertimeAssemblyCost
%
% Thus, profit = revenue - effective_material_cost - overtime_cost

solve maximize 
   ( sum(i in 1..N)( production[i] * Price[i] ) -
     ( if sum(i in 1..N)( production[i] * MaterialCost[i] ) >= DiscountThreshold then 
           sum(i in 1..N)( production[i] * MaterialCost[i] ) * (1 - MaterialDiscount/100)
       else 
           sum(i in 1..N)( production[i] * MaterialCost[i] )
       endif
     ) -
     ( if sum(i in 1..N)( production[i] * AssemblyHour[i] ) > MaxAssembly then
           ( sum(i in 1..N)( production[i] * AssemblyHour[i] ) - MaxAssembly ) * OvertimeAssemblyCost
       else
           0.0
       endif
     )
   );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output block
output [
  "Production quantities: ", show(production), "\n",
  "Profit: ", 
    show(
      sum(i in 1..N)( production[i] * Price[i] ) -
      ( if sum(i in 1..N)( production[i] * MaterialCost[i] ) >= DiscountThreshold then 
            sum(i in 1..N)( production[i] * MaterialCost[i] ) * (1 - MaterialDiscount/100)
        else 
            sum(i in 1..N)( production[i] * MaterialCost[i] )
        endif
      ) -
      ( if sum(i in 1..N)( production[i] * AssemblyHour[i] ) > MaxAssembly then
            ( sum(i in 1..N)( production[i] * AssemblyHour[i] ) - MaxAssembly ) * OvertimeAssemblyCost
        else 
            0.0
        endif
      )
    ),
  "\n"
];