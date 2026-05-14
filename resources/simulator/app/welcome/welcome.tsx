import * as wasm from "interlocking";
import Trackplan from "./trackplan.svg?react";

import configTxt from "./configuration.json?raw"
import { useEffect, useState } from "react";

enum OccupancyStatus {
  OCCUPIED = 0,
  VACANT = 1,
}

enum PointPosition {
  LEFT = 0,
  RIGHT = 1,
  NO_END_POSITION = 2,
  UNINTENDED_POSITION = 3,
}

enum TransitState {
  INACTIVE = 0,
  ACTIVE = 1,
}

export function Welcome() {
  const [running, setRunning] = useState(false);
  const [i, setI] = useState(0);
  const [config, setConfig] = useState<any>({});

  // Inputs to the simulator
  const [pointPositions, setPointPositions] = useState<number[]>([]);
  const [zoneOccupancies, setZoneOccupancies] = useState<number[]>([]);
  const [signalApproachStatuses, setSignalApproachStatuses] = useState<boolean[]>([]);

  // Outputs from the simulator
  const [signalStates, setSignalStates] = useState<{ [key: string]: boolean }>({});
  const [currentZoneOccupancies, setCurrentZoneOccupancies] = useState<{ [key: string]: OccupancyStatus }>({});
  const [currentTransitStates, setCurrentTransitStates] = useState<{ [key: string]: TransitState }>({});
  const [currentPointPositions, setCurrentPointPositions] = useState<{ [key: string]: PointPosition }>({});

  useEffect(() => {
    wasm.init(configTxt);
    const parsedConfig = JSON.parse(configTxt);
    setConfig(parsedConfig);
    // Initialize positions for each point to 0 (left)
    if (parsedConfig?.['Point']) {
      const initialPositions: number[] = new Array(parsedConfig['Point'].length).fill(0);
      parsedConfig['Point'].forEach((x: any, idx: number) => {
        wasm.set_point_position(idx, initialPositions[idx]);
      });
      setPointPositions(initialPositions);
    }

    if (parsedConfig?.['Zone']) {
      const initialZones: number[] = new Array(parsedConfig['Zone'].length).fill(1);
      parsedConfig['Zone'].forEach((x: any, idx: number) => {
        wasm.set_zone_occupancy_status(idx, initialZones[idx]);
      });
      setZoneOccupancies(initialZones);
    }

    if (parsedConfig?.['Signal']) {
      const initialSignals: boolean[] = new Array(parsedConfig['Signal'].length).fill(false);
      setSignalApproachStatuses(initialSignals);
    }
  }, []);

  const processOutputs = () => {
    // Process point commands
    config?.['Point']?.forEach((x: any, idx: number) => {
      const output = wasm.get_point_commanded_end_position(idx);
      if (output !== 0) {
        handlePointChange(idx, 2);

        setTimeout(() => {
          if (output === 1) {
            handlePointChange(idx, 0);
          } else if (output === 2) {
            handlePointChange(idx, 1);
          }
        }, 500);
      }
    });
    setCurrentPointPositions(prev => ({
      ...prev,
      ...config?.['Point']?.reduce((acc: any, x: any, idx: number) => {
        acc[x['name']] = wasm.get_point_current_position(idx) as PointPosition;
        return acc;
      }, {})
    }));

    // Process signal outputs and commands
    config?.['Signal']?.forEach((x: any, idx: number) => {
      const output = wasm.get_rbc_approach_status_requested(idx);
      if (output !== 0) {
        wasm.set_signal_approach_status(idx, signalApproachStatuses[idx] ? 1 : 0);
      }
    });
    setSignalStates(prev => ({
      ...prev,
      ...config?.['Signal']?.reduce((acc: any, x: any, idx: number) => {
        acc[x['name']] = wasm.get_signal_open(idx);
        return acc;
      }, {})
    }));

    // Process zone occupancies
    setCurrentZoneOccupancies(prev => ({
      ...prev,
      ...config?.['Zone']?.reduce((acc: any, x: any, idx: number) => {
        acc[x['name']] = wasm.get_zone_current_occupancy(idx) as OccupancyStatus;
        return acc;
      }, {})
    }));

    // Process transit states
    setCurrentTransitStates(prev => ({
      ...prev,
      ...config?.['Transit']?.reduce((acc: any, x: any, idx: number) => {
        acc[x['name']] = wasm.get_transit_status(idx) as TransitState;
        return acc;
      }, {})
    }));
  };

  useEffect(() => {
    if (i === 0) return;
    wasm.cycle(i);
    processOutputs();
  }, [i]);

  useEffect(() => {
    if (running) {
      const interval = setInterval(() => {
        setI(i => i + 1);
      }, 150);
      return () => clearInterval(interval);
    }
  }, [running]);

  const computePointFill = (currentZoneOccupancies: { [key: string]: OccupancyStatus }, currentTransitStates: { [key: string]: TransitState }, pointName: string) => {
    const zoneOccupied = currentZoneOccupancies[pointName] === OccupancyStatus.OCCUPIED;
    const anyTransitActive = currentTransitStates[`${pointName}_L+`] === TransitState.ACTIVE || currentTransitStates[`${pointName}_L-`] === TransitState.ACTIVE || currentTransitStates[`${pointName}_R+`] === TransitState.ACTIVE || currentTransitStates[`${pointName}_R-`] === TransitState.ACTIVE;
    return zoneOccupied ? 'red' : (anyTransitActive ? 'green' : 'gray');
  }

  const computePointLeftLegFill = (currentZoneOccupancies: { [key: string]: OccupancyStatus }, currentTransitStates: { [key: string]: TransitState }, pointName: string) => {
    const zoneOccupied = currentZoneOccupancies[pointName] === OccupancyStatus.OCCUPIED;
    const anyTransitActive = currentTransitStates[`${pointName}_L+`] === TransitState.ACTIVE || currentTransitStates[`${pointName}_L-`] === TransitState.ACTIVE;
    return zoneOccupied ? 'red' : (anyTransitActive ? 'green' : 'gray');
  }

  const computePointRightLegFill = (currentZoneOccupancies: { [key: string]: OccupancyStatus }, currentTransitStates: { [key: string]: TransitState }, pointName: string) => {
    const zoneOccupied = currentZoneOccupancies[pointName] === OccupancyStatus.OCCUPIED;
    const anyTransitActive = currentTransitStates[`${pointName}_R+`] === TransitState.ACTIVE || currentTransitStates[`${pointName}_R-`] === TransitState.ACTIVE;
    return zoneOccupied ? 'red' : (anyTransitActive ? 'green' : 'gray');
  }

  const computeSectionFill = (currentZoneOccupancies: { [key: string]: OccupancyStatus }, currentTransitStates: { [key: string]: TransitState }, sectionName: string) => {
    const zoneOccupied = currentZoneOccupancies[sectionName] === OccupancyStatus.OCCUPIED;
    const anyTransitActive = currentTransitStates[`${sectionName}+`] === TransitState.ACTIVE || currentTransitStates[`${sectionName}-`] === TransitState.ACTIVE;
    return zoneOccupied ? 'red' : (anyTransitActive ? 'green' : 'gray');
  }

  useEffect(() => {
    // Signals
    const a = document.getElementById('A') as unknown as SVGElement;
    if (a) {
      a.style.fill = signalStates['A'] ? 'green' : 'red';
    }

    const n1 = document.getElementById('N1') as unknown as SVGElement;
    if (n1) {
      n1.style.fill = signalStates['N1'] ? 'green' : 'red';
    }

    const n2 = document.getElementById('N2') as unknown as SVGElement;
    if (n2) {
      n2.style.fill = signalStates['N2'] ? 'green' : 'red';
    }

    // Track sections
    const g11 = document.getElementById('G11') as unknown as SVGElement;
    if (g11) {
      g11.style.fill = computeSectionFill(currentZoneOccupancies, currentTransitStates, 'G11');
    }

    const g12 = document.getElementById('G12') as unknown as SVGElement;
    if (g12) {
      g12.style.fill = computeSectionFill(currentZoneOccupancies, currentTransitStates, 'G12');
    }

    const g21 = document.getElementById('G21') as unknown as SVGElement;
    if (g21) {
      g21.style.fill = computeSectionFill(currentZoneOccupancies, currentTransitStates, 'G21');
    }

    const gxx = document.getElementById('GXX') as unknown as SVGElement;
    if (gxx) {
      gxx.style.fill = 'gray';
    }

    // Points
    const w1 = document.getElementById('W1') as unknown as SVGElement;
    if (w1) {
      w1.style.fill = computePointFill(currentZoneOccupancies, currentTransitStates, 'W1');
    }
    const w1l = document.getElementById('W1L') as unknown as SVGElement;
    if (w1l) {
      w1l.style.fill = computePointLeftLegFill(currentZoneOccupancies, currentTransitStates, 'W1');
      w1l.style.display = currentPointPositions['W1'] === 0 ? 'block' : 'none';
    }
    const w1r = document.getElementById('W1R') as unknown as SVGElement;
    if (w1r) {
      w1r.style.fill = computePointRightLegFill(currentZoneOccupancies, currentTransitStates, 'W1');
      w1r.style.display = currentPointPositions['W1'] === 1 ? 'block' : 'none';
    }
    const w1l2 = document.getElementById('W1L2') as unknown as SVGElement;
    if (w1l2) {
      w1l2.style.fill = computePointLeftLegFill(currentZoneOccupancies, currentTransitStates, 'W1');
    }

    const w2 = document.getElementById('W2') as unknown as SVGElement;
    if (w2) {
      w2.style.fill = computePointFill(currentZoneOccupancies, currentTransitStates, 'W2');
    }
    const w2l = document.getElementById('W2L') as unknown as SVGElement;
    if (w2l) {
      w2l.style.fill = computePointLeftLegFill(currentZoneOccupancies, currentTransitStates, 'W2');
      w2l.style.display = currentPointPositions['W2'] === 0 ? 'block' : 'none';
    }
    const w2r = document.getElementById('W2R') as unknown as SVGElement;
    if (w2r) {
      w2r.style.fill = computePointRightLegFill(currentZoneOccupancies, currentTransitStates, 'W2');
      w2r.style.display = currentPointPositions['W2'] === 1 ? 'block' : 'none';
    }
    const w2l2 = document.getElementById('W2L2') as unknown as SVGElement;
    if (w2l2) {
      w2l2.style.fill = computePointLeftLegFill(currentZoneOccupancies, currentTransitStates, 'W2');
    }
  }, [currentZoneOccupancies, currentTransitStates, currentPointPositions]);

  const toggle = () => {
    setRunning(!running);
  }

  const runSingle = () => {
    setI(i => i + 1);
  }

  const handlePointChange = (idx: number, value: number) => {
    setPointPositions(prev => {
      const updated = [...prev];
      wasm.set_point_position(idx, value);
      updated[idx] = value;
      return updated;
    });
  };

  const handleZoneChange = (idx: number, value: number) => {
    setZoneOccupancies(prev => {
      const updated = [...prev];
      wasm.set_zone_occupancy_status(idx, value);
      updated[idx] = value;
      return updated;
    });
  }

  const handleSignalApproachChange = (idx: number) => {
    setSignalApproachStatuses(prev => {
      const updated = [...prev];
      const newValue = !updated[idx];
      wasm.set_signal_approach_status(idx, newValue ? 1 : 0);
      updated[idx] = newValue;
      return updated;
    });
  }

  return (
    <main className="flex items-center justify-center pt-4 pb-4">
      <div className="flex-1 flex flex-col items-center gap-2 min-h-0">
        <div className="space-y-6 px-4">
          <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4 flex flex-row gap-4 align-middle">
            <div className="text-gray-700 dark:text-gray-200 min-w-50 text-center">
              Cycle {i}
            </div>
            <div>
              <input type="button" value={running ? "Pause" : "Start/Resume"} onClick={toggle} className="w-50 rounded-xl bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white font-medium px-4 py-2 text-center" />
            </div>
            <div>
              <input type="button" value="Single Step" disabled={running} onClick={runSingle} className="w-50 rounded-xl bg-blue-600 hover:bg-blue-700 active:bg-blue-800 disabled:bg-gray-400 text-white font-medium px-4 py-2 text-center" />
            </div>
          </div>
        </div>
        <header className="flex flex-col items-center gap-9">
          <div className="w-[800px] max-w-[100vw] p-4">
            <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4">
              <Trackplan />
            </div>
          </div>
        </header>
        <div>
          System Inputs
        </div>
        <div className="flex-1 flex flex-row flex-wrap justify-center gap-16 min-h-0">
          <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4 min-w-80">
            <h1 className="text-lg font-medium mb-2">SCI-P</h1>
            <h2 className="font-medium mb-2">Points</h2>
            {
              config?.['Point']?.map((x: any, idx: number) => (
                <div key={x['name']} className="mb-2">
                  <label className="mr-2">{x['name']}</label>
                  <select
                    value={pointPositions[idx] ?? 0}
                    onChange={e => handlePointChange(idx, Number(e.target.value))}
                    className="rounded border px-2 py-1"
                  >
                    <option value={0}>Left</option>
                    <option value={1}>Right</option>
                    <option value={2}>No end position</option>
                    <option value={3}>Unintended</option>
                  </select>
                </div>
              ))
            }
          </div>
          <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4 min-w-80">
            <h1 className="text-lg font-medium mb-2">SCI-TDS</h1>
            <h2 className="font-medium mb-2">Zones</h2>
            {
              config?.['Zone']?.map((x: any, idx: number) => (
                <div key={x['name']} className="mb-2">
                  <label className="mr-2">{x['name']}</label>
                  <select
                    value={zoneOccupancies[idx] ?? 0}
                    onChange={e => handleZoneChange(idx, Number(e.target.value))}
                    className="rounded border px-2 py-1"
                  >
                    <option value={0}>Occupied</option>
                    <option value={1}>Vacant</option>
                  </select>
                </div>
              ))
            }
          </div>
          <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4 min-w-80">
            <h1 className="text-lg font-medium mb-2">SCI-CC</h1>
            <h2 className="font-medium mb-2">Routes</h2>
            {
              config?.['Route']?.map((x: any, idx: number) => (
                <div key={x['name']} className="mb-2">
                  <label className="mr-2">{x['name']}</label>
                  <input type="button" value="Request" onClick={() => wasm.request_route(idx)} className="rounded bg-green-600 hover:bg-green-700 active:bg-green-800 text-white font-medium px-4 py-2 text-center" />
                  <input type="button" value="Release" onClick={() => wasm.release_route(idx)} className="rounded bg-red-600 hover:bg-red-700 active:bg-red-800 text-white font-medium px-4 py-2 text-center" />
                </div>
              ))
            }
          </div>
          <div className="rounded-3xl border border-gray-200 p-6 dark:border-gray-700 space-y-4 min-w-80">
            <h1 className="text-lg font-medium mb-2">SCI-RBC</h1>
            <h2 className="font-medium mb-2">ETCS Stop Marker Boards</h2>
            {
              config?.['Signal']?.map((x: any, idx: number) => (
                <div key={x['name']} className="mb-2">
                  <label className="mr-2">{x['name']}</label>
                  <input type="checkbox" checked={signalApproachStatuses[idx]} onChange={() => handleSignalApproachChange(idx)} className="mr-2" />
                  <label className="mr-2">Approach Taken</label>
                </div>
              ))
            }
          </div>
        </div>
      </div>
    </main>
  );
}
