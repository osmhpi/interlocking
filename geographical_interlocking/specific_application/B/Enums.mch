MACHINE Enums
SETS
  EulynxEndPosition = {EulynxEndPosition_LEFT, EulynxEndPosition_RIGHT, EulynxEndPosition_NO_END_POSITION, EulynxEndPosition_UNINTENDED};
  EulynxCommandedEndPosition = {EulynxCommandedEndPosition_NOT_COMMANDED, EulynxCommandedEndPosition_LEFT, EulynxCommandedEndPosition_RIGHT};
  OccupancyStatus = {OccupancyStatus_OCCUPIED, OccupancyStatus_VACANT};
  RouteState = {RouteState_SET, RouteState_PREPARING, RouteState_RELEASED};
  ActiveInactive = {ActiveInactive_INACTIVE, ActiveInactive_ACTIVE};
  PointState = {PointState_LEFT, PointState_RIGHT, PointState_UNDETERMINED};
  OpenCloseState = {OpenCloseState_OPEN, OpenCloseState_CLOSED};
  RouteAdmission = {RouteAdmission_INACTIVE, RouteAdmission_ADMIT_TO_A, RouteAdmission_ADMIT_TO_B, RouteAdmission_ADMIT_TO_C, RouteAdmission_ADMIT_END, RouteAdmission_ROUTE_TO_A, RouteAdmission_ROUTE_TO_B, RouteAdmission_ROUTE_TO_C, RouteAdmission_ROUTE_END};
  RouteChecking = {RouteChecking_INACTIVE, RouteChecking_CHECK_START, RouteChecking_CHECK_FROM_A, RouteChecking_CHECK_FROM_B, RouteChecking_CHECK_FROM_C, RouteChecking_ROUTE_SET_FROM_START, RouteChecking_ROUTE_SET_FROM_A, RouteChecking_ROUTE_SET_FROM_B, RouteChecking_ROUTE_SET_FROM_C};
  RouteSearch = {RouteSearch_INACTIVE, RouteSearch_SEARCH, RouteSearch_RESPONSE, RouteSearch_ROUTE_SET, RouteSearch_ROUTE_MONITORED}
END