const assert = require('assert')
const ganache = require('ganache-cli')
const Web3 = require('web3') 
const web3 = new Web3(ganache.provider());
const {interface,bytecode} = require('../compile.js')

let accounts;
let bank;
beforeEach(async ()=>{
    accounts = await web3.eth.getAccounts();
    
    bank = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({data:JSON.parse(bytecode),arguments:[0]})
    .send({from:accounts[0],gas:'3000000'});
})

describe('Bank',async ()=>{
    it('contract got address',async()=>{
        assert.ok(bank.options.address)
    })
})