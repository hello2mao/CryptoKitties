pragma solidity ^0.4.19;

contract ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    function balanceOf(address _owner) public view returns (uint256 _balance);
    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function transfer(address _to, uint256 _tokenId) public;
    function approve(address _to, uint256 _tokenId) public;
    function takeOwnership(uint256 _tokenId) public;
}


library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


contract Ownable {

    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

///
/// Below is Thing Contract
///

/// 产品生产者
contract ThingFactory is Ownable {

    using SafeMath for uint256;

    // 生产一个产品后的通知事件
    event NewThing(address indexed _from, uint thingId, string name, uint dna);
    // 日志事件
    event LogStatus(address indexed _from, string log);

    // 基因位数
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // 技能冷却时间
    uint cooldownTime = 1 days;

    struct Thing {
        string name;       // 名字
        uint price;        // 价格
        uint dna;          // DNA
        uint32 level;      // 等级
        uint32 readyTime;  // 技能冷却
        uint32 generation; // 代数
        uint16 winCount;   // 战斗胜利次数
        uint16 lossCount;  // 战斗失败次数
    }

    Thing[] public things;

    // _tokenId <==> _owner
    mapping (uint => address) public thingToOwner;
    // _owner <==> _tokenCount
    mapping (address => uint) ownerThingCount;

    function _createThing(string _name, uint _dna, uint32 _generation) internal {
        require(msg.sender != address(0));

        // 配置默认产品
        Thing memory _thing;
        _thing.name = _name;
        _thing.price = (_dna / 100) % 100;
        _thing.dna = _dna;
        _thing.level = uint32(1);
        _thing.readyTime = uint32(now);
        _thing.generation = _generation;
        _thing.winCount = uint16(0);
        _thing.lossCount = uint16(0);

        // 记录到区块链
        uint id = things.push(_thing) - 1;
        thingToOwner[id] = msg.sender;
        ownerThingCount[msg.sender]++;

        // 通知事件
        NewThing(msg.sender, id, _name, _dna);
    }

    function _generateRandomDna(string _str) internal view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    // 对外接口，用于生产产品
    function createRandomThing(string _name, uint _limit) public {
        require(ownerThingCount[msg.sender] <= _limit);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createThing(_name, randDna, uint32(0));
    }
}

/// 繁育&喂养系统
contract ThingFeedAndBreed is ThingFactory {

    modifier onlyOwnerOf(uint _thingId) {
        require(msg.sender == thingToOwner[_thingId]);
        _;
    }

    function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function _triggerCooldown(Thing storage _thing) internal {
        _thing.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Thing storage _thing) internal view returns (bool) {
        return (_thing.readyTime <= now);
    }

    function feedAndMultiply(uint _thingId, uint _targetDna, string _species) internal onlyOwnerOf(_thingId) {
        Thing storage myThing = things[_thingId];
        require(_isReady(myThing));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myThing.dna + _targetDna) / 2;
        // 吃了Kitty后，dna最后两个数字设定为99
        // 例如：7290459416715799
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createThing(strConcat("n",myThing.name, "", "", ""), newDna, myThing.generation + 1);
        _triggerCooldown(myThing);
    }

    // 喂养
    function feedOnKitty(uint _thingId, uint _kittyId) public {
        // 使用_kittyId作为kittyDna
        uint kittyDna = _kittyId;
        // (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_thingId, kittyDna, "kitty");
    }

    // 繁育
    function breed(uint _thingId, uint _targetThingId) public {
        uint _targetDna = things[_targetThingId].dna;
        feedAndMultiply(_thingId, _targetDna, "thing");
    }
}

/// 升级系统
contract ThingUpgrade is ThingFeedAndBreed {

    // 默认升级费用 1 ETH
    uint levelUpFee = 1 ether;

    modifier aboveLevel(uint _level, uint _thingId) {
        require(things[_thingId].level >= _level);
        _;
    }

    // 设置升级费用
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // 升级
    function levelUp(uint _thingId) external payable {
        require(msg.value == levelUpFee);
        things[_thingId].level++;
    }

    // 2级可以改名
    function changeName(uint _thingId, string _newName) external aboveLevel(2, _thingId) onlyOwnerOf(_thingId) {
        things[_thingId].name = _newName;
    }

    // 20级可以定制Dna
    function changeDna(uint _thingId, uint _newDna) external aboveLevel(20, _thingId) onlyOwnerOf(_thingId) {
        things[_thingId].dna = _newDna;
    }
}

/// 对战系统
contract ThingAttack is ThingUpgrade {

    uint randNonce = 0;
    // 攻击方将有70%的几率获胜，防守方将有30%的几率获胜
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    // 两个产品互相对战
    function attack(uint _thingId, uint _targetId) external onlyOwnerOf(_thingId) {
        Thing storage myThing = things[_thingId];
        Thing storage enemyThing = things[_targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myThing.winCount++;
            myThing.level++;
            enemyThing.lossCount++;
            feedAndMultiply(_thingId, enemyThing.dna, "thing");
        } else {
            myThing.lossCount++;
            enemyThing.winCount++;
            _triggerCooldown(myThing);
        }
    }
}

/// 辅助合约
contract ThingHelper is ThingAttack {

    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    // 对外接口，返回相应owner的产品Id数组
    function getThingsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerThingCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < things.length; i++) {
            if (thingToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // 对外接口，返回对应Id的产品
    function getThing(uint _thingId) public view returns (
        string name,
        uint price,
        uint dna,
        uint32 level,
        uint32 readyTime,
        uint32 generation,
        uint16 winCount,
        uint16 lossCount) {
        Thing storage thing = things[_thingId];
        name = thing.name;
        price = thing.price;
        dna = thing.dna;
        level = thing.level;
        readyTime = thing.readyTime;
        generation = thing.generation;
        winCount = thing.winCount;
        lossCount = thing.lossCount;
    }
}

/// ERC721 Impl
contract ThingCore is ThingHelper, ERC721 {

    using SafeMath for uint256;

    mapping (uint => address) thingApprovals;

    // ERC721 impl
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerThingCount[_owner];
    }

    // ERC721 impl
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return thingToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerThingCount[_to] = ownerThingCount[_to].add(1);
        ownerThingCount[_from] = ownerThingCount[_from].sub(1);
        thingToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    // ERC721 impl
    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    // ERC721 impl
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        thingApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    // ERC721 impl
    function takeOwnership(uint256 _tokenId) public {
        require(thingApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

    function buyThing(uint _thingId) public payable {
        address owner = thingToOwner[_thingId];
        _transfer(owner, msg.sender, _thingId);
    }
}