module.exports = {
    networks: {
        development: {
            host: "example.com/jsonrpc/9987e857-46b7-49c9-8c3a-59c24a0944f0",
            port: 80,
            from: "0xad1da3cee12D353Ae08dCa4370C51138E4751d35",
            // gas: 4712388, // web3.eth.getBlock("pending").gasLimit
            network_id: "*"
        }
    }
};
