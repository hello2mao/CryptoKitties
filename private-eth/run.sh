#!/bin/sh

# clear data
rm -rf data
mkdir data

# init genesis
geth init --datadir data genesis.json >> geth.log 2>&1

# import account
geth --datadir data account import account/k1.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k2.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k3.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k4.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k5.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k6.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k7.txt --password account/pw.txt >> geth.log 2>&1
geth --datadir data account import account/k8.txt --password account/pw.txt >> geth.log 2>&1

# start geth
geth --datadir data --networkid 15 --mine --nodiscover --rpc --rpcport 8545 --rpccorsdomain "*" --rpcapi "admin,clique,debug,miner,net,rpc,eth,txpool,web3,personal" --rpcaddr 0.0.0.0 --unlock "0x3A834e8c4ab7CfF61C11F71129205020bd828533,0x673751313d2E477F789F0a1f0A4Fc4208ba908b3,0xcf7EC987043f1314F2BB7ba8963fcEA2e15a1b18,0x44fE4bce1867C7bA318aA6A7bEB1d0795db3cA62,0xe9B1ADcFfF8cAbA1371C10210FFB49A91058d7b9,0xa7383b6C584f10f3e7f870AcB3495C9B907264f1,0xEc0D61b303C2ECEd7d18B166D70f7C7DC69c379B,0xFCed13a4232257B371c910293A840EAC1863FF0A" --password account/pw.txt >> geth.log 2>&1 &

echo "run success."
