const fs = require("fs");
const { ethers } = require("ethers");

async function createContractWithSigner() {
  const zpayAddress = "0x4078f13fD4a21BF4F2d89ebbdb0A735F2fE9A934";
  const zpayABI_str = fs.readFileSync("zpay.json", "utf8");
  const zpayABI = JSON.parse(zpayABI_str);

  const bpAddress = "0xA3646F20D83CD4EB4d5cB334135fA9fc52c2D08E";
  const bpABI_str = fs.readFileSync("blockchainParking.json", "utf8");
  const bpABI = JSON.parse(bpABI_str);

  const account_str = fs.readFileSync("settings.json", "utf8");
  const account = JSON.parse(account_str);
  console.log("==========1==========");

  console.log(account);

  const provider = new ethers.providers.JsonRpcProvider(account.holeskyrpc);

  const pk2 = account.pk2;
  console.log("==========2==========");
  console.log(pk2);

  const wallet = new ethers.Wallet(pk2, provider);

  // 创建合约实例
  const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
  const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);

  return { zpayContract, bpContract };
}

async function deposit(value_wei) {
  try {
    const { bpContract } = await createContractWithSigner();
    console.log(bpContract);

    const tx = await bpContract.deposit({value:value_wei});
    await tx.wait();
    console.log("注册成功");
  } catch (error) {
    console.error("注册失败:", error);
  }
}

deposit(2);








