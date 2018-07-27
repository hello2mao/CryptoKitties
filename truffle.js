module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 7545,
            from: "0x13379Ec77e75012DdE8b0B08B1ff446F4065f52A",
            // gas: 4712388, // web3.eth.getBlock("pending").gasLimit
            network_id: "*"
        }
    }
};
