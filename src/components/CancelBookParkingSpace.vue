<template>
  <div class="CancelBookParkingSpace toolsView">
    <button @click="cancelBookParkingSpace" class="css-button-arrow--red">
      取消车位
    </button>
    <input type="text" v-model="id" placeholder="请输入取消车位ID" />
  </div>
  <p>{{ info }}</p>
</template>

<script>
import { ethers } from "ethers";
export default {
  name: "CancelBookParkingSpace",
  data() {
    return {
      id: "",
      info: "",
      address: "",
      zpayABI_str: require("../assets/zpay.json"),
      bpABI_str: require("../assets/blockchainParking.json"),
    };
  },
  methods: {
    async linkWallet() {
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
    },
    async createContractWithSigner() {
      // 代币合约信息
      const zpayAddress = "0x4078f13fD4a21BF4F2d89ebbdb0A735F2fE9A934";
      const zpayABI = this.zpayABI_str;

      // 停车场合约信息
      const bpAddress = "0xA3646F20D83CD4EB4d5cB334135fA9fc52c2D08E";
      const bpABI = this.bpABI_str;
      console.log("---以上正确---");

      const wallet = new ethers.providers.Web3Provider(window.ethereum);
      const signer = wallet.getSigner();

      // 创建合约实例
      const zpayContract = new ethers.Contract(zpayAddress, zpayABI, wallet);
      const zpayContractWithSigner = zpayContract.connect(signer);
      const bpContract = new ethers.Contract(bpAddress, bpABI, wallet);
      const bpContractWithSigner = bpContract.connect(signer);

      return { zpayContractWithSigner, bpContractWithSigner };
    },

    async cancelBookParkingSpace() {
      await this.linkWallet();
      console.log("==========1==========");
      const { bpContractWithSigner } = await this.createContractWithSigner();

      try {
        const tx = await bpContractWithSigner.cancelBookParkingSpace(this.id);
        await tx.wait();
        this.info = tx;
        console.log("添加成功");
      } catch (error) {
        this.info = error;
        console.error("失败:", error);
      }
    },
  },
};
</script>

<style>
.toolsView {
  margin: 10px;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}
.css-button-arrow--red {
  min-width: 130px;
  height: 40px;
  color: #fff;
  padding: 5px 10px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  display: inline-block;
  outline: none;
  overflow: hidden;
  border-radius: 5px;
  border: none;
  background-color: #ef233c;
}
.css-button-arrow--red:hover {
  border-radius: 5px;
  padding-right: 24px;
  padding-left: 8px;
}
.css-button-arrow--red:hover:after {
  opacity: 1;
  right: 10px;
}
.css-button-arrow--red:after {
  content: "\00BB";
  position: absolute;
  opacity: 0;
  font-size: 20px;
  line-height: 40px;
  top: 0;
  right: -20px;
  transition: 0.4s;
}
</style>
