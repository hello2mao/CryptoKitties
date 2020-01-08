CryptoKitties
=========================

A simple implementation of CryptoKitties with more tricks.

More Info：[Ethereum-ERC721智能合约和Dapp实践--以太猫CryptoKitties的简单实现](https://hello2mao.github.io/2018/07/27/ethereum-erc721-demo/)

![image](/img/1.png)

# Feature

 * 交易系统：用户可使用帐号在商店里对产品进行买卖交易。
 * 繁育系统：用户可以使用已有的产品与繁殖中心的产品进行繁殖，产生新的产品。
 * 对战系统：用户可以使用已有的产品与对战心中的产品进行对战，赢了将升级并产生一个新产品，输了失败次数将加一。
 * 喂养系统：用户可以对已有的产品喂养以太坊公链上的以太猫，从而产生新的带以太猫基因的杂交品种。
 * 升级系统：用户可以对已有的产品花ETH进行升级，2级以后可以改名，20级后可以定制DNA，从而用户激励升级。

# Quick Start

```shell
docker run --name=dapp-slim -p 3000:3000 -p 8545:8545 -d hello2mao/crypto-kitties:slim
```

# License


    Copyright (C) 2018 hello2mao.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
