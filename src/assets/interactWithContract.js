import { readFileSync } from "fs";
import { providers, Contract } from "ethers";

// const account = readFileSync("account.json", "utf8");
// const holeskyprc = JSON.parse(account).holeskyrpc;

async function linkWallet() {
  // 检查浏览器是否有okx钱包
  if (!window.okxwallet) {
    alert("请先安装okx钱包");
  } else {
    const okx = window.okxwallet;
    // 检测钱包是否连接
    if (!okx.isConnected()) {
      alert("请先连接钱包");
      try {
        const accounts = await okx.request({ method: "eth_requestAccounts" });
        console.log("连接成功", accounts[0]);
      } catch (error) {
        console.error("连接失败:", error);
      }
    } else {
      console.log("钱包已连接");
    }
  }
}
async function createContractWithSigner() {
  // 代币合约信息
  const zpayAddress = "0x4078f13fD4a21BF4F2d89ebbdb0A735F2fE9A934";
  const zpayABI_str = fs.readFileSync("zpay.json", "utf8");
  const zpayABI = JSON.parse(zpayABI_str);

  // 停车场合约信息
  const bpAddress = "0xA3646F20D83CD4EB4d5cB334135fA9fc52c2D08E";
  const bpABI_str = fs.readFileSync("blockchainParking.json", "utf8");
  const bpABI = JSON.parse(bpABI_str);

  // 读取本地账号
  //   const settings_str = fs.readFileSync("account.json", "utf8");
  //   const settings = JSON.parse(settings_str);
  //   const provider = new ethers.providers.JsonRpcProvider(settings.holeskyrpc);

  const wallet = new ethers.providers.Web3Provider(window.ethereum);
  // 创建合约实例
  const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
  const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);

  return { zpayContract, bpContract };
}
/* ==============不消耗gas============== */

// 管理员查看合约金额(用户充值的eth)
async function getBalanceOfContract() {
  await linkWallet();
  const { bpContract } = await createContractWithSigner();
  try {
    const operator = await bpContract.getBalanceOfContract();
    console.log("合约管理员:", operator);
  } catch (error) {
    console.log("获取失败:", error);
  }
}

// 系统管理员地址
async function operator() {
  await linkWallet();
  const { bpContract } = createContractWithSigner();
  try {
    const balance = await bpContract.operator();
    console.log("合约余额:", balance);
  } catch (error) {
    console.error("获取余额失败:", error);
  }
}
// 查看总共的停车位数量

async function totalParkingSpace() {
  const contract = createContractWithSigner();
  try {
    const balance = await contract.bpContract.balance();
    console.log("合约余额:", balance);
  } catch (error) {
    console.error("获取余额失败:", error);
  }
}
// // 查看现在能用的停车位数量
// // availableParkingSpace

// // 查看支付代币合约地址
async function zpay() {
  const contract = createContractWithSigner();
  try {
    const zpay = await contract.bpContract.zpay();
    console.log("合约余额:", zpay);
  } catch (error) {
    console.error("获取余额失败:", error);
  }
}
// // 现在发布的停车位数量

async function operator() {
  const contract = createContractWithSigner();
  try {
    const nowParkingSpace = await contract.nowParkingSpace.balance();
    console.log("合约余额:", nowParkingSpace);
  } catch (error) {
    console.error("获取余额失败:", error);
  }
}
// // 用户查看自己的余额 ZT代币
// ZTbalance
async function ZTbalance(account) {
  const contract = createContractWithSigner();
  try {
    const ZTbalance = await contract.bpContract.ZTbalance(account);
    console.log("合约余额:", ZTbalance);
  } catch (error) {
    console.error("获取余额失败:", error);
  }
}
// // 查看id车位对应的主人
// parkingSpaceID_owner
// // 查看id车位的占用状态
// parkingSpaceID_occupied
// // 查看id车位的占用人
// parkingSpaceID_bookbyer
// // 查看id车位占用人的开始时间
// parkingSpaceID_starttime
// // 查看id车位占用人的占用时长
// parkingSpaceID_duration

/* ==============消耗gas和eth============== */

// 注册
async function registerWith5wei() {
  const contract = createContractWithSigner();
  try {
    const value = 5; // 以太币的最小单位（wei），等于 0.000005 ETH
    const tx = await contract.bpContract.registerWith5wei({ value });
    await tx.wait();
    console.log("注册成功");
  } catch (error) {
    console.error("注册失败:", error);
  }
}

// 存款

async function deposit(value) {
  const contract = createContractWithSigner();
  try {
    const tx = await contract.bpContract.deposit(value);
    await tx.wait();
    console.log("注册成功");
  } catch (error) {
    console.error("注册失败:", error);
  }
}

export { registerWith5wei };
