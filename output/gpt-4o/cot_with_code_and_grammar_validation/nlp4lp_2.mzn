int: N;
set of int: SYSTEMS = 1..N;

array[SYSTEMS] of bool: IsWorkstation;
array[SYSTEMS] of float: Price;
array[SYSTEMS] of float: DiskDrives;
array[SYSTEMS] of int: MemoryBoards;

int: MaxCpu;
int: MinDisk;
int: MaxDisk;
int: MinMemory;
int: MaxMemory;

array[SYSTEMS] of int: Demand;
int: DemandGP;
int: DemandWS;
array[SYSTEMS] of int: Preorder;

int: AltMemory;
array[SYSTEMS] of bool: AltCompatible;

array[SYSTEMS] of var float: Produce;
array[SYSTEMS] of var float: AltUsed;

constraint forall(i in SYSTEMS)(Produce[i] >= 0.0 /\ AltUsed[i] >= 0.0);

constraint
  forall(i in SYSTEMS)(
      Produce[i] >= int2float(Preorder[i]) /\
      Produce[i] <= int2float(Demand[i])
  );

constraint
  sum(i in SYSTEMS)(Produce[i]) <= int2float(MaxCpu);

constraint
  int2float(MinDisk) <= sum(i in SYSTEMS)(DiskDrives[i] * Produce[i]);

constraint
  sum(i in SYSTEMS)(DiskDrives[i] * Produce[i]) <= int2float(MaxDisk);

constraint
  forall(i in SYSTEMS)(
      AltUsed[i] <= int2float(MemoryBoards[i]) * Produce[i] /\
      AltUsed[i] <= (if AltCompatible[i] then int2float(MemoryBoards[i]) * Produce[i] else 0.0 endif)
  );

constraint
  sum(i in SYSTEMS)(AltUsed[i]) <= int2float(AltMemory);

var float: TotalStdMem =
  sum(i in SYSTEMS)(int2float(MemoryBoards[i]) * Produce[i]) - sum(i in SYSTEMS)(AltUsed[i]);

constraint
  int2float(MinMemory) <= TotalStdMem;

constraint
  TotalStdMem <= int2float(MaxMemory);

constraint
  sum(i in SYSTEMS where not IsWorkstation[i])(Produce[i]) <= int2float(DemandGP);

constraint
  sum(i in SYSTEMS where IsWorkstation[i])(Produce[i]) <= int2float(DemandWS);

solve maximize sum(i in SYSTEMS)(Price[i] * Produce[i]);