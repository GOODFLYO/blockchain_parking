async function linkWallet() {
  // 检查浏览器是否有okx钱包
  if (!window.ethereum) {
    alert("请先安装okx钱包");
  } else {
    const okx = window.ethereum;

    // 检测钱包是否连接
    if (!okx.isConnected()) {
      // alert("请先连接钱包");
      try {
        const accounts = await okx.request({
          method: "eth_requestAccounts",
        });
        this.address = accounts[0];
        console.log("连接成功", accounts[0]);
      } catch (error) {
        console.error("连接失败:", error);
      }
    } else {
      const accounts = await okx.request({
        method: "eth_requestAccounts",
      });
      this.address = accounts[0];
      console.log("钱包已连接", okx.selectedAddress);
    }
  }
}
async function createContractWithSigner() {
  // 代币合约信息
  const zpayAddress = "0x4078f13fD4a21BF4F2d89ebbdb0A735F2fE9A934";
  const zpayABI = this.zpayABI_str;

  // 停车场合约信息
  const bpAddress = "0xA3646F20D83CD4EB4d5cB334135fA9fc52c2D08E";
  const bpABI = this.bpABI_str;

  const wallet = new ethers.providers.Web3Provider(window.ethereum);
  // 创建合约实例
  const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
  const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);

  return { zpayContract, bpContract };
}
