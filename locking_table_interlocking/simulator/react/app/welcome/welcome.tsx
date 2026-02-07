import * as wasm from "locking_table_interlocking";

import configTxt from "./configuration.json?raw"
import { useEffect, useState } from "react";

export function Welcome() {
  const [running, setRunning] = useState(false);
  const [i, setI] = useState(0);
  const [config, setConfig] = useState<any>({});

  // Inputs
  const [pointPositions, setPointPositions] = useState<number[]>([]);
  const [zoneOccupancies, setZoneOccupancies] = useState<number[]>([]);
  const [signalApproachStatuses, setSignalApproachStatuses] = useState<boolean[]>([]);

  // Outputs
  const [signalStates, setSignalStates] = useState<{ [key: string]: boolean }>({});
  const [currentZoneOccupancies, setCurrentZoneOccupancies] = useState<{ [key: string]: number }>({});
  const [currentTransitStates, setCurrentTransitStates] = useState<{ [key: string]: boolean }>({});
  const [currentPointPositions, setCurrentPointPositions] = useState<{ [key: string]: number }>({});

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
        acc[x['name']] = wasm.get_point_current_position(idx);
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
        acc[x['name']] = wasm.get_zone_current_occupancy(idx);
        return acc;
      }, {})
    }));

    // Process transit states
    setCurrentTransitStates(prev => ({
      ...prev,
      ...config?.['Transit']?.reduce((acc: any, x: any, idx: number) => {
        acc[x['name']] = wasm.get_transit_status(idx) === 1;
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
              <svg width="100%" height="100%" viewBox="0 0 653 283" version="1.1" xmlns="http://www.w3.org/2000/svg">
                  <g transform="matrix(1,0,0,1,-19,-83)">
                      <g>
                          <g id="W1" transform="matrix(0.611228,0,0,0.535306,123.941,107.362)" style={{fill: currentZoneOccupancies['W1'] === 1 ? ((currentTransitStates['W1_L+'] || currentTransitStates['W1_L-'] || currentTransitStates['W1_R+'] || currentTransitStates['W1_R-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="G11" transform="matrix(1.07277,0,0,0.535306,-78.5582,107.362)" style={{fill: currentZoneOccupancies['G11'] === 1 ? ((currentTransitStates['G11+'] || currentTransitStates['G11-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="G12" transform="matrix(2.32784,0,0,0.535306,108.239,107.362)" style={{fill: currentZoneOccupancies['G12'] === 1 ? ((currentTransitStates['G12+'] || currentTransitStates['G12-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W1L2" transform="matrix(0.473274,-0.473274,0.378519,0.378519,101.694,182.17)" style={{fill: currentZoneOccupancies['W1'] === 1 ? ((currentTransitStates['W1_L+'] || currentTransitStates['W1_L-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W2L2" transform="matrix(0.473274,-0.473274,0.378519,0.378519,172.404,111.459)" style={{fill: currentZoneOccupancies['W2'] === 1 ? ((currentTransitStates['W2_L+'] || currentTransitStates['W2_L-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W1R" transform="matrix(0.334655,0,0,0.535306,240.562,107.362)" style={{fill: currentZoneOccupancies['W1'] === 1 ? ((currentTransitStates['W1_R+'] || currentTransitStates['W1_R-']) ? 'green' : 'gray') : 'red', display: currentPointPositions['W1'] === 1 ? 'block' : 'none'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g transform="matrix(2.67322,0,0,0.535306,-224.956,-98.8697)" style={{fill: 'gray'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W2" transform="matrix(0.570288,0,0,0.535306,416.805,-98.8697)" style={{fill: currentZoneOccupancies['W2'] === 1 ? ((currentTransitStates['W2_L+'] || currentTransitStates['W2_L-'] || currentTransitStates['W2_R+'] || currentTransitStates['W2_R-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="G21" transform="matrix(0.768334,0,0,0.535306,483.894,-98.8697)" style={{fill: currentZoneOccupancies['G21'] === 1 ? ((currentTransitStates['G21+'] || currentTransitStates['G21-']) ? 'green' : 'gray') : 'red'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W2R" transform="matrix(0.334655,0,0,0.535306,388.359,-98.8697)" style={{fill: currentZoneOccupancies['W2'] === 1 ? ((currentTransitStates['W2_R+'] || currentTransitStates['W2_R-']) ? 'green' : 'gray') : 'red', display: currentPointPositions['W2'] === 1 ? 'block' : 'none'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W1L" transform="matrix(0.236637,-0.236637,0.378519,0.378519,87.9765,195.819)" style={{fill: currentZoneOccupancies['W1'] === 1 ? ((currentTransitStates['W1_L+'] || currentTransitStates['W1_L-']) ? 'green' : 'gray') : 'red', display: currentPointPositions['W1'] === 0 ? 'block' : 'none'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="W2L" transform="matrix(0.236637,-0.236637,0.378519,0.378519,264.716,19.0848)" style={{fill: currentZoneOccupancies['W2'] === 1 ? ((currentTransitStates['W2_L+'] || currentTransitStates['W2_L-']) ? 'green' : 'gray') : 'red', display: currentPointPositions['W2'] === 0 ? 'block' : 'none'}}>
                              <rect x="91.473" y="388.763" width="149.407" height="37.362"/>
                          </g>
                          <g id="A" transform="matrix(1,0,0,1,20.5878,67.1524)" style={{fill: signalStates['A'] ? 'green' : 'red'}}>
                              <g transform="matrix(0.986792,0,0,0.779456,0.892597,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.779456,-35.7941,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(0.567835,0,0,0.567835,33.6977,117.547)">
                                  <circle cx="147.722" cy="301.177" r="17.611"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.389728,-55.7941,175.001)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                          </g>
                          <g id="N2" transform="matrix(1,0,0,1,517.034,67.1524)" style={{fill: signalStates['N2'] ? 'green' : 'red'}}>
                              <g transform="matrix(0.986792,0,0,0.779456,0.892597,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.779456,-35.7941,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(0.567835,0,0,0.567835,33.6977,117.547)">
                                  <circle cx="147.722" cy="301.177" r="17.611"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.389728,-55.7941,175.001)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                          </g>
                          <g id="N1" transform="matrix(1,0,0,1,517.034,-140.367)" style={{fill: signalStates['N1'] ? 'green' : 'red'}}>
                              <g transform="matrix(0.986792,0,0,0.779456,0.892597,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.779456,-35.7941,61.4359)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                              <g transform="matrix(0.567835,0,0,0.567835,33.6977,117.547)">
                                  <circle cx="147.722" cy="301.177" r="17.611"/>
                              </g>
                              <g transform="matrix(1.97358,0,0,0.389728,-55.7941,175.001)">
                                  <rect x="67.579" y="278.566" width="10.134" height="25.659"/>
                              </g>
                          </g>
                          <g transform="matrix(1,0,0,1,-54.9013,58.0328)">
                              <g transform="matrix(12,0,0,12,222.552,301.98)">
                              </g>
                              <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>A</text>
                          </g>
                          <g transform="matrix(1,0,0,1,443.038,58.0679)">
                              <g transform="matrix(12,0,0,12,229.888,301.98)">
                              </g>
                              <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>N1</text>
                          </g>
                          <g transform="matrix(1,0,0,1,64.8995,58.0679)">
                              <g transform="matrix(12,0,0,12,232.548,301.98)">
                              </g>
                              <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>W1</text>
                          </g>
                          <g transform="matrix(1,0,0,1,239.882,-209.893)">
                              <g transform="matrix(12,0,0,12,232.548,301.98)">
                              </g>
                              <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>W2</text>
                          </g>
                          <g transform="matrix(1,0,0,1,442.253,-149.469)">
                              <g transform="matrix(12,0,0,12,229.888,301.98)">
                              </g>
                              <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>N2</text>
                          </g>
                          <g>
                              <g transform="matrix(0.650136,0,0,0.508144,26.386,196.982)">
                                  <rect x="145.373" y="233.176" width="46.144" height="39.359" style={{fill: 'white'}}/>
                              </g>
                              <g transform="matrix(1,0,0,1,-88.7635,27.7835)">
                                  <g transform="matrix(12,0,0,12,236.339,301.98)">
                                  </g>
                                  <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>G11</text>
                              </g>
                          </g>
                          <g transform="matrix(1,0,0,1,0,-206.231)">
                              <g transform="matrix(0.650136,0,0,0.508144,506.959,196.982)">
                                  <rect x="145.373" y="233.176" width="46.144" height="39.359" style={{fill: 'white'}}/>
                              </g>
                              <g transform="matrix(1,0,0,1,391.809,27.7835)">
                                  <g transform="matrix(12,0,0,12,237.23,301.98)">
                                  </g>
                                  <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>G21</text>
                              </g>
                              <g transform="matrix(0.650136,0,0,0.508144,506.959,403.213)">
                                  <rect x="145.373" y="233.176" width="46.144" height="39.359" style={{fill: 'white'}}/>
                              </g>
                              <g transform="matrix(1,0,0,1,391.809,234.015)">
                                  <g transform="matrix(12,0,0,12,237.23,301.98)">
                                  </g>
                                  <text x="214.548px" y="301.98px" style={{fontFamily: 'Arial', fontSize: '12px'}}>G12</text>
                              </g>
                          </g>
                      </g>
                  </g>
              </svg>
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
