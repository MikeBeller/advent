// Run with 
//      node --experimental-wasm-bigint test_wasm_node.js
const fs = require('fs')
bytes = new Uint8Array(fs.readFileSync('./2020-23.wasm'))
wasm = WebAssembly.instantiate(bytes, {}).then(mod => console.log(mod.instance.exports.main()));
