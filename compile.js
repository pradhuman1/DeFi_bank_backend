const path = require('path');
const fs = require('fs');
const solc = require('solc')


const bankPath = path.resolve(__dirname,'contracts/Bank.sol');
const source = fs.readFileSync(bankPath,'utf8');

var input = {
    language: 'Solidity',
    sources: {
        'Bank.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    }
}; 

const output =JSON.parse(solc.compile(JSON.stringify(input)));
const interface = JSON.stringify(output.contracts["Bank.sol"].Bank.abi);
const bytecode = JSON.stringify(output.contracts["Bank.sol"].Bank.evm.bytecode.object);

console.log(interface);


module.exports = {interface,bytecode}