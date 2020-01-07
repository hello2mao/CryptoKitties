var accountPrivKeys = [
    '6aa931d33e1b2f0711ec8531ee9f856809137c47c736853070b7042609e27ec7',
    'd7bde311a5275c0772da231144201053cc180abb5f9d4d2276d464b70e874ae7',
    '1d1671b5d9e4c7ec691ed5211c08319e8ed20f187224cc1f783eb5b441535fa6',
    'db985da6fefb81b12c36997b991a1e3b44b66b1fcf615fe9e003fa5d3b11cc78',
    '0ee3f0ac2abc00453fd11ae25e60b82e0129392d5ad7de4ea36d1011559bb639',
    '619d316088b697c85ad1d9331ae01d9acbddb318cc704fc40de62ff17bc2e3da',
    'ab900185b94700488362b6fbb87406f6df66f69524cbaa3b554179d3c2896b93'
];

for (index in accountPrivKeys) {
    console.log('process importRawKey: ' + accountPrivKeys[index]);
    try {
        web3.personal.importRawKey(accountPrivKeys[index], '123');
    }
    catch (e) {
        console.log('ignore err:', e);
    }
}
var accounts = eth.accounts;
for (index in accounts) {
    try {
        console.log('unlock account: ' + accounts[index]);
        personal.unlockAccount(accounts[index], '123', 999999999);
    }
    catch (e) {
        console.log('ignore err:', e);
    }
}
