int: A;
int: S;

array[1..A] of float: AvailableAlloy;
array[1..A] of float: CarbonContent;
array[1..A] of float: NickelContent;
array[1..A] of float: AlloyPrice;

array[1..S] of float: SteelPrice;
array[1..S] of float: CarbonMin;
array[1..S] of float: NickelMax;

/* Decision variables */
array[1..A, 1..S] of var 0.0..1.0e6: UseAlloy;   % tons of alloy a used in steel s
array[1..S]              of var 0.0..1.0e6: SteelProduced; % tons of steel type s produced

/* Material balance: every ton of steel consists of alloys */
constraint
  forall(s in 1..S)(
    sum(a in 1..A)(UseAlloy[a,s]) = SteelProduced[s]
  );

/* Do not exceed available stock of each alloy */
constraint
  forall(a in 1..A)(
    sum(s in 1..S)(UseAlloy[a,s]) <= AvailableAlloy[a]
  );

/* Minimum carbon content requirement for each steel type */
constraint
  forall(s in 1..S)(
    sum(a in 1..A)(CarbonContent[a] * UseAlloy[a,s]) >=
      CarbonMin[s] * SteelProduced[s]
  );

/* Maximum nickel content for each steel type */
constraint
  forall(s in 1..S)(
    sum(a in 1..A)(NickelContent[a] * UseAlloy[a,s]) <=
      NickelMax[s] * SteelProduced[s]
  );

/* At most 40 % of alloy 1 in any steel type */
constraint
  forall(s in 1..S)(
    UseAlloy[1,s] <= 0.4 * SteelProduced[s]
  );

/* Objective: maximise profit */
solve maximize
  sum(s in 1..S)(SteelPrice[s] * SteelProduced[s]) -
  sum(a in 1..A, s in 1..S)(AlloyPrice[a] * UseAlloy[a,s]);