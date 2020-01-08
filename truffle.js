module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            from: "0x3A834e8c4ab7CfF61C11F71129205020bd828533",
            // gas: 4712388, // web3.eth.getBlock("pending").gasLimit
            network_id: "*"
        }
    }
};
