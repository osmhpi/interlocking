MACHINE RouteCheck
SEES Enums
SETS
  STATETYPE_RouteCheck_root = { STATE_RouteCheck_root___initial, STATE_RouteCheck_root_INACTIVE, STATE_RouteCheck_root_WAITING, STATE_RouteCheck_root_CHECKING, STATE_RouteCheck_root_c }
VARIABLES
  RouteRequested,
  IsTop,
  Top,
  State,
  GraphState_root
INVARIANT
  RouteRequested : BOOL &
  IsTop : BOOL &
  Top : E_ActiveInactive &
  State : E_ActiveInactive &
  GraphState_root : STATETYPE_RouteCheck_root
INITIALIZATION
  RouteRequested := FALSE;
  IsTop := FALSE;
  Top := ActiveInactive_ACTIVE;
  State := ActiveInactive_INACTIVE;
  GraphState_root := STATE_RouteCheck_root___initial
OPERATIONS
  InitialTransition(SCICC_MsgRequestRoute, all_routes_RouteCheck_Top) =
    BEGIN
      // Update Terms
      RouteRequested := bool(SCICC_MsgRequestRoute = TRUE) ||
      IsTop := bool(({ActiveInactive_ACTIVE} = all_routes_RouteCheck_Top or {} = all_routes_RouteCheck_Top));
      // Perform transition
        Top := ActiveInactive_ACTIVE;
      State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteCheck_root_INACTIVE
    END;
  Transition(SCICC_MsgRequestRoute, all_routes_RouteCheck_Top) =
    BEGIN
      // Update Terms
      RouteRequested := bool(SCICC_MsgRequestRoute = TRUE) ||
      IsTop := bool(({ActiveInactive_ACTIVE} = all_routes_RouteCheck_Top or {} = all_routes_RouteCheck_Top));
      // Perform transition
      SELECT GraphState_root = STATE_RouteCheck_root_INACTIVE THEN 
        IF RouteRequested = TRUE THEN

        IF IsTop = TRUE THEN
Top := ActiveInactive_INACTIVE;
      State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteCheck_root_CHECKING
        ELSE
        Top := ActiveInactive_ACTIVE;
      State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteCheck_root_WAITING
        END

        END
      END;
      SELECT GraphState_root = STATE_RouteCheck_root_CHECKING THEN 
        Top := ActiveInactive_ACTIVE;
      State := ActiveInactive_INACTIVE;
          GraphState_root := STATE_RouteCheck_root_INACTIVE
      END;
      SELECT GraphState_root = STATE_RouteCheck_root_WAITING THEN 
        IF IsTop = TRUE THEN
Top := ActiveInactive_INACTIVE;
      State := ActiveInactive_ACTIVE;
          GraphState_root := STATE_RouteCheck_root_CHECKING
        END
      END
    END
END//MACHINE
