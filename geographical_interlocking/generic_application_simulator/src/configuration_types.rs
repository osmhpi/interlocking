//! Auto-generated Rust types and parser for configuration.schema.json

use typify::import_types;

use serde::{Deserialize, Serialize};

import_types!("configuration.schema.json");

pub fn parse_configuration(json: &str) -> Result<Entities, serde_json::Error> {
    serde_json::from_str::<Entities>(json)
}
