MACHINE RouteAutomaticRelease
SEES Enums
SETS
  STATE_RouteAutomaticRelease_root = { STATE_RouteAutomaticRelease_root___initial, STATE_RouteAutomaticRelease_root_INACTIVE, STATE_RouteAutomaticRelease_root_ACTIVE, STATE_RouteAutomaticRelease_root_EFFECTIVE }
VARIABLES
  RouteIsSet,
  OppositeTransitsInactive,
  TriggerZoneFree,
  State,
  GraphState
INVARIANT
  RouteIsSet : BOOL &
  OppositeTransitsInactive : BOOL &
  TriggerZoneFree : BOOL &
  State : ActiveInactive &
  GraphState : STATE_RouteAutomaticRelease_root
INITIALIZATION
  RouteIsSet := FALSE;
  OppositeTransitsInactive := TRUE;
  TriggerZoneFree := FALSE;
  State := ActiveInactive_INACTIVE;
  GraphState := STATE_RouteAutomaticRelease_root___initial
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      RouteIsSet := Route_State = RouteState_SET ||
      OppositeTransitsInactive := !(transit).(transit : dom(trigger_zone_opposite_transits_Transit_State) => trigger_zone_opposite_transits_Transit_State(transit) = ActiveInactive_INACTIVE ) ||
      TriggerZoneFree := @trigger_zone_Zone_State = OccupancyStatus_VACANT;
      // Perform transition
      SELECT GraphState = STATE_RouteAutomaticRelease_root___initial THEN
        GraphState := STATE_RouteAutomaticRelease_root___initial
      END;
    END
  Transition(Route_State, trigger_zone_opposite_transits_Transit_State, trigger_zone_Zone_State) =
    BEGIN
      // Update Terms
      RouteIsSet := Route_State = RouteState_SET ||
      OppositeTransitsInactive := !(transit).(transit : dom(trigger_zone_opposite_transits_Transit_State) => trigger_zone_opposite_transits_Transit_State(transit) = ActiveInactive_INACTIVE ) ||
      TriggerZoneFree := @trigger_zone_Zone_State = OccupancyStatus_VACANT;
      // Perform transition
      SELECT GraphState = STATE_RouteAutomaticRelease_root___initial THEN
        GraphState := STATE_RouteAutomaticRelease_root___initial
      END
    END
END//MACHINE
