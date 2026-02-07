mod graphs;
mod entity_types;

pub mod configuration_types;
mod schedule;
mod graph;
mod enums;
mod eval_context;
mod triggerable;
mod timestamp;

use std::fs;

use crate::{enums::{EulynxEndPosition, OccupancyStatus}, schedule::ScheduleBuilder, triggerable::Triggerable};

fn main() {
    let json = fs::read_to_string("../specific_application/configuration.json").expect("Failed to read configuration.json");

    if let Ok(config) = configuration_types::parse_configuration(&json) {
        println!("{:#?}", config);
        let mut schedule = ScheduleBuilder::new(config).build();

        // Initial state of inputs

        schedule.Point_SCIP.get_mut(0).unwrap().DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::LEFT);
        schedule.Point_SCIP.get_mut(1).unwrap().DetectedEndPosition = Triggerable::Triggered(EulynxEndPosition::RIGHT);

        schedule.Zone_SCITDS.get_mut(0).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);
        schedule.Zone_SCITDS.get_mut(1).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);
        schedule.Zone_SCITDS.get_mut(2).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);

        let mut i = 0;

        // Initial transition
        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        // Request a route
        schedule.Route_SCICC.get_mut(0).unwrap().MsgRequestRoute = Triggerable::Triggered(true);

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        schedule.Zone_SCITDS.get_mut(0).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::OCCUPIED);

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        schedule.Zone_SCITDS.get_mut(0).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);
        schedule.Zone_SCITDS.get_mut(1).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::OCCUPIED);

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        schedule.Zone_SCITDS.get_mut(1).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);
        schedule.Zone_SCITDS.get_mut(2).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::OCCUPIED);

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;

        schedule.Zone_SCITDS.get_mut(2).unwrap().OccupancyStatus = Triggerable::Triggered(OccupancyStatus::VACANT);

        schedule.transition(timestamp::timestamp { milliseconds: Some(i * 150) });
        i += 1;
    } else {
        eprintln!("Failed to parse configuration");
    }
}
