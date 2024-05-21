// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "src/ZPay.sol";

contract blockchian_parking {
    struct User {
        address username;
        bool isRegistered;
    }

    struct Map {
        uint256 longitude; //经度
        uint256 latitude; //纬度
    }

    //停车位
    struct ParkingSpace {
        // uint256 parkingLotNumber; //所属停车场编号
        uint256 parkingSpaceID; //停车位编号
        address owner; //停车位主人
        bool isOccupied; //占用状态
        address bookedBy; //谁预定的
        uint256 bookingStartTime; //预定时间
        uint256 duration; //时长
    }

    mapping(address => User) public users;
    mapping(uint256 => Map) public maps;

    modifier onlyRegisteredUser() {
        require(
            users[msg.sender].isRegistered || msg.sender == operator,
            "Only registered users can access this function."
        );
        _;
    }

    function registerWith5wei() public payable returns (string memory) {
        require(msg.value == 5, "not enough");
        require(!users[msg.sender].isRegistered, "User is already registered.");
        users[msg.sender] = User(msg.sender, true);
        return "success";
    }

    address public operator; //系统管理员
    // uint256 public totalParkingLot; //停车场总数
    uint256 public totalParkingSpace; //停车位总数
    // uint256 public nowParkingNumber;
    ZPay public zpay; //引入支付通证

    // mapping(uint256 => ParkingLot) public parkingLotNumber_ParkingLot; //编号对应停车场
    mapping(address => uint256) public owner_parkingSpaceID; //地址主人对应停车位编号
    // mapping(uint256 => ParkingSpace) public parkingSpaceID_ParkingSpace; //编号对应停车位信息
    mapping(uint256 => address) public parkingSpaceID_owner; //编号对应主人信息
    mapping(uint256 => bool) public parkingSpaceID_occupied; //某停车位状态
    mapping(uint256 => address) public parkingSpaceID_bookbyer; //车位占有人
    mapping(uint256 => uint256) public parkingSpaceID_starttime; //车位开始时间
    mapping(uint256 => uint256) public parkingSpaceID_duration; //车位时间
    mapping(address => uint256) public ZTbalance; //账户余额

    event Deposit_Event(address dpren, uint256 dpqian);
    event Withdraw_Event(address wdren, uint256 wdqian);
    event WithdrawOperator_Event(address, uint256 wdqian);

    event AddParkingSpace_Event(
        uint256 addParkingSpaceTime,
        uint256 addparkingSpaceID
    );

    event BookingParking_Event(
        address booker,
        address psowner,
        uint256 starttime,
        uint256 duration
    );
    event CancelBookingParking_Event(address booker, address psowner);

    constructor(address ztoken) {
        operator = msg.sender;
        totalParkingSpace = 0;
        // nowParkingNumber = 1;
        zpay = ZPay(ztoken);
    }

    // // 停车场
    // struct ParkingLot {
    //     uint256 parkingLotNumber; //停车场编号
    //     uint256 remainingSpace; //这个停车场还剩下多少车位
    //     ParkingSpace[] parkingSpace; //车位信息
    // }

    // 权限管理
    modifier onlyOperator() {
        require(msg.sender == operator);
        _;
    }

    receive() external payable {}

    // 功能1：获取合约当前以太
    function getBalanceOfContract() public view returns (uint256) {
        return address(this).balance;
    }

    // 功能2：获取用户ZT存款
    function getZTBalance() public view returns (uint256) {
        return ZTbalance[msg.sender];
    }

    // 功能3：购买zt
    function exchangeToken()
        external
        payable
        onlyRegisteredUser
        returns (uint256)
    {
        require(msg.value != 0);
        ZTbalance[msg.sender] = ZTbalance[msg.sender] + msg.value;
        zpay.transferFrom(operator, msg.sender, msg.value);
        emit Deposit_Event(msg.sender, msg.value);
        return ZTbalance[msg.sender];
    }

    // 功能4：提款zt
    function withdraw(uint256 wd) external onlyRegisteredUser {
        require(wd <= ZTbalance[msg.sender], "balance is not enough");
        ZTbalance[msg.sender] = ZTbalance[msg.sender] - wd;
        zpay.transfer(msg.sender, wd);
        emit Withdraw_Event(msg.sender, wd);
    }

    // 功能5：管理员提取合约的以太
    function withdraw_operator(
        address receiver,
        uint256 wd
    ) external onlyOperator {
        require(wd <= address(this).balance, "balance is not enough");
        require(receiver != address(0));
        address payable caller = payable(receiver);
        caller.transfer(wd);

        emit WithdrawOperator_Event(msg.sender, wd);
    }

    // 管理员增加停车位数量==>如何自动增加车位？时间戳？
    // function addTotalParkingSpace(uint256 addingSpace)
    //     private
    //     onlyOperator
    //     returns (uint256)
    // {
    //     require(addingSpace > 0, "DATA ERROR");
    //     totalParkingSpace = totalParkingSpace + addingSpace;
    //     emit AddParkingSpace_Event(block.timestamp, addingSpace);
    //     return totalParkingSpace;
    // }

    //功能6：初始化车位
    function setParkingSpaceStatus(
        uint256 id,
        address owner,
        bool isOccupied,
        address bookbyer,
        uint256 starttime,
        uint256 duration
    ) internal {
        parkingSpaceID_owner[id] = owner; //
        parkingSpaceID_occupied[id] = isOccupied;
        parkingSpaceID_bookbyer[id] = bookbyer;
        parkingSpaceID_starttime[id] = starttime;
        parkingSpaceID_duration[id] = duration;
    }

    // 功能7：用户发布停车位 系统指定
    function addParkingSpace()
        external
        onlyRegisteredUser
        returns (uint256 psNumber)
    {
        // require(nowParkingNumber < totalParkingSpace, "parking is not enough");
        psNumber = totalParkingSpace + 1;
        setParkingSpaceStatus(psNumber, msg.sender, false, address(0), 0, 0);
        owner_parkingSpaceID[msg.sender] = psNumber;
        totalParkingSpace++;
        return psNumber;
    }

    // 功能8：用户发布停车位 用户自己指定
    function addParkingSpace(
        uint256 id
    ) external onlyRegisteredUser returns (uint256) {
        require(id <= totalParkingSpace);
        require(parkingSpaceID_owner[id] == address(0));
        setParkingSpaceStatus(id, msg.sender, false, address(0), 0, 0);
        owner_parkingSpaceID[msg.sender] = id;
        return id;
    }

    // 功能9：删除指定停车位
    function deleteParkingSpace(
        uint256 id
    ) external onlyRegisteredUser returns (bool) {
        require(id <= totalParkingSpace, "id error");
        require(parkingSpaceID_owner[id] == msg.sender);
        require(parkingSpaceID_occupied[id] == false);
        setParkingSpaceStatus(id, address(0), false, address(0), 0, 0);
        owner_parkingSpaceID[msg.sender] = 0;
        return true;
    }

    // 功能10：预约车位 费用暂时设置为 1
    function bookParkingSpace(
        uint256 id,
        uint256 startTime,
        uint256 duration
    ) external onlyRegisteredUser returns (bool) {
        require(ZTbalance[msg.sender] > 1, "balance is not enough");
        require(id <= totalParkingSpace, "this ps is not existing");
        require(parkingSpaceID_occupied[id] == false, "ps is occupied");
        require(duration > 0 && startTime > block.timestamp + 120); //超过当前120秒

        setParkingSpaceStatus(
            id,
            parkingSpaceID_owner[id],
            true,
            msg.sender,
            startTime,
            duration
        );
        ZTbalance[msg.sender]--;
        ZTbalance[parkingSpaceID_owner[id]]++;

        emit BookingParking_Event(
            msg.sender,
            parkingSpaceID_owner[id],
            startTime,
            duration
        );

        return true;
    }

    // 功能11：取消预约车位 费用暂时设置为 1
    function cancelBookParkingSpace(
        uint256 id
    ) external onlyRegisteredUser returns (bool) {
        require(id <= totalParkingSpace, "this ps is not existing");
        require(parkingSpaceID_occupied[id] == true, "ps is not occupied");
        require(parkingSpaceID_bookbyer[id] == msg.sender);
        setParkingSpaceStatus(
            id,
            parkingSpaceID_owner[id],
            false,
            address(0),
            0,
            0
        );

        ZTbalance[msg.sender]++;
        ZTbalance[parkingSpaceID_owner[id]]--;
        emit CancelBookingParking_Event(msg.sender, parkingSpaceID_owner[id]);

        return true;
    }

    // 功能12：添加车位经纬度
    function addPositionTude(
        uint256 longitude,
        uint256 latitude
    ) public pure returns (Map memory) {
        return Map(longitude, latitude);
    }

    // 功能13：查看拥有的车位
    function getOnwerParikingSpace(address add) public view returns (uint256) {
        return owner_parkingSpaceID[add];
    }

    // 功能14：查看编号对应主人信息
    function getParikingSpaceOwner(uint256 id) public view returns (address) {
        return parkingSpaceID_owner[id];
    }

    // 功能15：查看车位占用信息
    function getIDOccupied(uint256 id) public view returns (bool) {
        return parkingSpaceID_occupied[id];
    }

    // 功能16：查看车位预约信息
    function getParikingSpaceBooker(uint256 id) public view returns (address) {
        return parkingSpaceID_bookbyer[id];
    }

    // 功能16：查看注册情况
    function getisRegister(address add) public view returns (bool) {
        return users[add].isRegistered;
    }
}
