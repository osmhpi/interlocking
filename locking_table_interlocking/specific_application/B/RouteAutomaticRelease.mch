MACHINE RouteAutomaticRelease
SEES Enums
SETS
  STATE_RouteAutomaticRelease_root = { STATE_RouteAutomaticRelease_root___initial, STATE_RouteAutomaticRelease_root_INACTIVE, STATE_RouteAutomaticRelease_root_ACTIVE, STATE_RouteAutomaticRelease_root_EFFECTIVE }
VARIABLES
  RouteIsSet,
  OppositeTransitsInactive,
  TriggerZoneFree,
  State,
  PassageLock,
  GraphState_root
INVARIANT
  RouteIsSet : BOOL &
  OppositeTransitsInactive : BOOL &
  TriggerZoneFree : BOOL &
  State : ActiveInactive &
  PassageLock : ActiveInactive &
  GraphState_root : STATE_RouteAutomaticRelease_root
INITIALIZATION
  RouteIsSet := FALSE;
  OppositeTransitsInactive := FALSE;
  TriggerZoneFree := FALSE;
  State := ActiveInactive_INACTIVE;
  PassageLock := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteAutomaticRelease_root___initial
OPERATIONS
  InitialTransition(Route_State, trigger_zone_opposite_transit_Transit_State, trigger_zone_Zone_State) =
    BEGIN
      // Update Terms
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      OppositeTransitsInactive := bool(trigger_zone_opposite_transit_Transit_State = ActiveInactive_INACTIVE) ||
      TriggerZoneFree := bool(trigger_zone_Zone_State = OccupancyStatus_VACANT);
      // Perform transition
        State := ActiveInactive_INACTIVE;
      PassageLock := ActiveInactive_INACTIVE;
        GraphState_root := STATE_RouteAutomaticRelease_root_INACTIVE
    END;
  Transition(Route_State, trigger_zone_opposite_transit_Transit_State, trigger_zone_Zone_State) =
    BEGIN
      // Update Terms
      RouteIsSet := bool(Route_State = RouteState_SET) ||
      OppositeTransitsInactive := bool(trigger_zone_opposite_transit_Transit_State = ActiveInactive_INACTIVE) ||
      TriggerZoneFree := bool(trigger_zone_Zone_State = OccupancyStatus_VACANT);
      // Perform transition
      SELECT GraphState_root = STATE_RouteAutomaticRelease_root_INACTIVE THEN 
        IF RouteIsSet = TRUE & OppositeTransitsInactive = TRUE & not(TriggerZoneFree = TRUE) THEN
State := ActiveInactive_INACTIVE;
      PassageLock := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteAutomaticRelease_root_ACTIVE

        END
      END;
      SELECT GraphState_root = STATE_RouteAutomaticRelease_root_ACTIVE THEN 
        IF not(RouteIsSet = TRUE) THEN
State := ActiveInactive_INACTIVE;
      PassageLock := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteAutomaticRelease_root_INACTIVE

        ELSIF TriggerZoneFree = TRUE THEN
State := ActiveInactive_ACTIVE;
      PassageLock := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteAutomaticRelease_root_EFFECTIVE

        END
      END;
      SELECT GraphState_root = STATE_RouteAutomaticRelease_root_EFFECTIVE THEN 
        IF not(RouteIsSet = TRUE) THEN
State := ActiveInactive_INACTIVE;
      PassageLock := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteAutomaticRelease_root_INACTIVE

        END
      END
    END
END//MACHINE
