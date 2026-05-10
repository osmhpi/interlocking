mod graphs;
mod entity_types;

pub mod configuration_types;
mod schedule;
mod graph;
mod enums;
mod eval_context;
mod triggerable;
mod timestamp;

use wasm_bindgen::prelude::*;

use crate::{enums::{EulynxCommandedEndPosition, EulynxEndPosition, OccupancyStatus}, schedule::{Schedule, ScheduleBuilder}, triggerable::Triggerable};

static mut SCHEDULE: Option<Schedule> = None;

#[wasm_bindgen]
pub fn init(json: &str) {
    if let Ok(config) = configuration_types::parse_configuration(&json) {
        unsafe { SCHEDULE = Some(ScheduleBuilder::new(config).build()) };
        // alert("ok")
      } else {
        // alert("Failed to parse configuration");
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn cycle(i: u32) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            schedule.transition(timestamp::timestamp { milliseconds: Some((i * 150).into()) });
        }
    }
}


#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn set_signal_approach_status(i: u32, status: u8) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let signal = schedule.Signal_SCIRBC.get_mut(i as usize).unwrap();
            match status {
                0 => signal.ApproachLockingActive = Triggerable::Triggered(false),
                1 => signal.ApproachLockingActive = Triggerable::Triggered(true),
                _ => (),
            }
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn set_point_position(i: u32, position: u8) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let point = schedule.Point_SCIP.get_mut(i as usize).unwrap();
            match position {
                0 => point.DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::LEFT),
                1 => point.DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::RIGHT),
                2 => point.DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::NO_END_POSITION),
                3 => point.DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::UNINTENDED),
                _ => (),
            }
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn set_zone_occupancy_status(i: u32, status: u8) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let zone = schedule.Zone_SCITDS.get_mut(i as usize).unwrap();
            match status {
                0 => zone.OccupancyStatus = Triggerable::Triggered(OccupancyStatus::OCCUPIED),
                1 => zone.OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT),
                _ => (),
            }
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn request_route(i: u32) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let route = schedule.Route_SCICC.get_mut(i as usize).unwrap();
            route.MsgRequestRoute = Triggerable::Triggered(true);
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn release_route(i: u32) {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let route = schedule.Route_SCICC.get_mut(i as usize).unwrap();
            route.MsgReleaseRoute = Triggerable::Triggered(true);
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_point_commanded_end_position(i: u32) -> u8 {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let point = schedule.Point_SCIP.get_mut(i as usize).unwrap();
            match point.CommandedEndPosition {
                EulynxCommandedEndPosition::NOT_COMMANDED => 0,
                EulynxCommandedEndPosition::LEFT => 1,
                EulynxCommandedEndPosition::RIGHT => 2,
            }
        } else {
            0
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_rbc_approach_status_requested(i: u32) -> u8 {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let signal = schedule.Signal_SCIRBC.get_mut(i as usize).unwrap();
            match signal.ApproachStatusRequested {
                true => 1,
                false => 0,
            }
        } else {
            0
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_signal_open(i: u32) -> bool {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let signal = schedule.Signal_SCICC.get_mut(i as usize).unwrap();
            signal.SignalOpen
        } else {
            false
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_zone_current_occupancy(i: u32) -> u8 {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let zone = schedule.Zone_SCICC.get_mut(i as usize).unwrap();
            match zone.CurrentOccupancy {
                OccupancyStatus::OCCUPIED => 0,
                OccupancyStatus::VACANT => 1,
            }
        } else {
            1
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_transit_status(i: u32) -> u8 {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let transit = schedule.Transit_SCICC.get_mut(i as usize).unwrap();
            match transit.Active {
                true => 1,
                false => 0,
            }
        } else {
            1
        }
    }
}

#[wasm_bindgen]
#[allow(static_mut_refs)]
pub fn get_point_current_position(i: u32) -> u8 {
    unsafe {
        if let Some(schedule) = &mut SCHEDULE {
            let point = schedule.Point_SCICC.get_mut(i as usize).unwrap();
            match point.CurrentPosition {
                EulynxEndPosition::LEFT => 0,
                EulynxEndPosition::RIGHT => 1,
                EulynxEndPosition::NO_END_POSITION => 2,
                EulynxEndPosition::UNINTENDED => 3,
            }
        } else {
            2
        }
    }
}
