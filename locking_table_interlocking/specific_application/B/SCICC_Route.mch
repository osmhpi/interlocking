MACHINE SCICC_Route
SEES Enums
VARIABLES
  MsgRequestRoute,
  MsgReleaseRoute
INVARIANT
  MsgRequestRoute : BOOL &
  MsgReleaseRoute : BOOL
INITIALIZATION
  MsgRequestRoute := FALSE;
  MsgReleaseRoute := FALSE
OPERATIONS
  Set_MsgRequestRoute(value) = MsgRequestRoute := value;
  Set_MsgReleaseRoute(value) = MsgReleaseRoute := value;
  ComputeOutputs = skip
END//MACHINE
